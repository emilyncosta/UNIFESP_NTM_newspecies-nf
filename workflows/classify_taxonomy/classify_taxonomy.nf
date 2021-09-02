nextflow.enable.dsl = 2

/*
Taken from BACTpipe - https://github.com/ctmrbio/BACTpipe v3.1
*/

params.kraken2_confidence = 0.5
params.kraken2_min_proportion = 1.00

params.resultsDir = "${params.outdir}/kraken2"
params.saveMode = 'copy'
params.shouldPublish = true


process CLASSIFY_TAXONOMY {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    
    input:
    tuple val(genomeName), path(reads)
    path(kraken2_db)
    path(kraken2_gram_stain)

    output:
    path "${genomeName}.kreport"
    path "${genomeName}.classification.txt", emit: classification

    script:
		"""
		kraken2 \
			--quick \
			--db ${kraken2_db} \
			--threads ${task.cpus} \
			--confidence ${params.kraken2_confidence} \
			--output - \
			--report ${genomeName}.kreport \
			--use-names \
			--paired \
			${reads[0]} ${reads[1]}
		
		classify_kreport.py \
			--kreport ${genomeName}.kreport \
			--min-proportion ${params.kraken2_min_proportion} \
			--gramstains ${kraken2_gram_stain} \
			> ${genomeName}.classification.txt
		"""


    stub:
    """
    touch ${genomeName}.kreport
    touch ${genomeName}.classification.txt
    """
}

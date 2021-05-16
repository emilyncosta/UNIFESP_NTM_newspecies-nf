nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/unicycler"
params.saveMode = 'copy'
params.shouldPublish = true

process UNICYCLER {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("*${genomeName}/${genomeName}.contigs.fasta")
    path("${genomeName}")

    script:

    """
    unicycler  \
    -t ${task.cpus} \
    --keep 0 \
    --short1 ${genomeReads[0]} \
    --short2 ${genomeReads[1]} \
    --out ${genomeName} 

    cp ${genomeName}/assembly.fasta ${genomeName}/${genomeName}.contigs.fasta
    """


    stub:
    """
    echo "unicycler  \
    -t ${task.cpus} \
    --keep 0 \
    --short1 ${genomeReads[0]} \
    --short2 ${genomeReads[1]} \
    --out ${genomeName}"

    
    mkdir ${genomeName}
    touch ${genomeName}/${genomeName}.contigs.fasta

    """

}


workflow test {

    input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

    UNICYCLER(input_ch)

}

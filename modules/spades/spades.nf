nextflow.enable.dsl=2


params.resultsDir = "${params.outdir}/spades"
params.shouldPublish= true
params.saveMode = 'copy'

process SPADES {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode
    container 'quay.io/biocontainers/spades:3.14.0--h2d02072_0'
    cpus 8
    memory "15 GB"

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("${genomeName}_scaffolds.fasta")


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}
    cp ${genomeName}/scaffolds.fasta ${genomeName}_scaffolds.fasta 
    """
}



workflow test {

params.TRIMMOMATIC = [
	shouldPublish: false
]


include { TRIMMOMATIC } from "../trimmomatic/trimmomatic.nf" addParams( params.TRIMMOMATIC )

input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

TRIMMOMATIC(input_ch)

SPADES(TRIMMOMATIC.out)



}

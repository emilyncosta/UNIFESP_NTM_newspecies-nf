nextflow.enable.dsl=2


params.saveMode = 'copy'
params.resultsDir = "${params.outdir}/quast"
params.shouldPublish = true


process QUAST {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/quast:5.0.2--py37pl526hb5aa323_2'
    cpus 8
    memory "15 GB"


    input:
    path(scaffoldFiles)
    path(reference)

    output:
    path("quast_results")


    script:

    """
    quast -r ${reference} -t ${task.cpus} ${scaffoldFiles} 

    """

    stub:
    """
    echo "quast -r ${reference} -t ${task.cpus} ${scaffoldFiles}"

    mkdir quast_results

    """
}

workflow test {
    include { TRIMMOMATIC } from "../trimmomatic/trimmomatic.nf"
    include { SPADES } from "../spades/spades.nf"

    input_reads_ch = Channel.fromFilePairs("$launchDir/data/mock_data/*_{R1,R2}*fastq.gz")

    TRIMMOMATIC(input_reads_ch)

    SPADES(TRIMMOMATIC.out)

    QUAST(SPADES.out.collect())

}


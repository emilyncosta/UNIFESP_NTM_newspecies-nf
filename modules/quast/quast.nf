nextflow.enable.dsl = 2


params.save_mode = 'copy'
params.results_dir = "${params.outdir}/quast"
params.should_publish = true


process QUAST {
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

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


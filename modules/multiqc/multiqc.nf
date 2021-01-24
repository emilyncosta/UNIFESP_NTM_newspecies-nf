nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/fastqc"
params.saveMode = 'copy'
params.shouldPublish = true


process MULTIQC {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/multiqc:1.9--pyh9f0ad1d_0'
    cpus 4
    memory "8 GB"

    input:
    path("""${params.fastqcResultsDir}""") from ch_in_multiqc

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""") into ch_out_multiqc


    script:

    """
    multiqc ${params.fastqcResultsDir}
    """

}







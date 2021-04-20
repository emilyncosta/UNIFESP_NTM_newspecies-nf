nextflow.enable.dsl = 2

params.fastqcResultsDir = "${params.outdir}/fastqc"
params.resultsDir = "${params.outdir}/multiqc"
params.saveMode = 'copy'
params.shouldPublish = true


process MULTIQC {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish

    input:
    path("*")

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""")


    script:

    """
    multiqc .
    """

    stub:
    """
    mkdir multiqc_data

    touch multiqc_report.html
    """
}







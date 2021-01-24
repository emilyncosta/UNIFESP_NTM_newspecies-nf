nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/snippy"
params.saveMode = 'copy'
params.shouldPublish = true

process SNIPPY {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/snippy:1.14.6--pl526_0'
    cpus 8
    memory "15 GB"

    input:
    tuple val(genomeName),  path(bestContig)

    output:
    path("${genomeName}")

    script:

    """
    snippy --outdir ${genomeName} --prefix $genomeName ${bestContig} --cpus ${task.cpus}
    """

}


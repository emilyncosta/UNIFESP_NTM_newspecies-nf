nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/orthoani_combined_result"
params.saveMode = 'copy'
params.shouldPublish = true

process UTILS_COMBINE_ORTHOANI_RESULTS_TSV {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish


    input:
    path(all_orthoani_result)


    output:
    path("*tsv")


    script:

    """
    cat *.tsv > orthoani_combined_result.tsv
    """

    stub:
    """
    touch ${orthoani_result}.tsv

    """
}

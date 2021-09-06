nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/orthoani_combined_result"
params.save_mode = 'copy'
params.should_publish = true

process UTILS_COMBINE_ORTHOANI_RESULTS_TSV {
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish


    input:
    path(all_orthoani_result)


    output:
    path("orthoani_combined_result.tsv")


    script:

    """
    cat *.tsv > orthoani_combined_result.tsv
    """

    stub:
    """
    touch orthoani_combined_result.tsv
    """
}

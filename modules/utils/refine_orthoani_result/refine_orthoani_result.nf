nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/orthoani_results_tsv"
params.save_mode = 'copy'
params.should_publish = true

process UTILS_REFINE_ORTHOANI_RESULT {
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish


    input:
    path(orthoani_result)


    output:
    path("*tsv")


    shell:

    // TODO: Make the insertion of new line elegant

    '''
    awk '$1=$1' ORS='\t' !{orthoani_result} > !{orthoani_result}.tsv
    echo "
    " >>  !{orthoani_result}.tsv
    '''

    stub:
    """
    touch ${orthoani_result}.tsv

    """
}

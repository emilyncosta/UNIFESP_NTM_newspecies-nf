nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/orthoani_results_tsv"
params.saveMode = 'copy'
params.shouldPublish = true

process UTILS_REFINE_ORTHOANI_RESULT {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish


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

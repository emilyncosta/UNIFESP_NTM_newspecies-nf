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


    shell:

    '''
    cat *.tsv > combined_result.tmp.tsv
    echo -e "OrthoANI value (%)\tGenome1\tGenome2" > orthoani_combined_result.tsv
    grep "\S"  combined_result.tmp.tsv >> orthoani_combined_result.tsv
    '''

    stub:
    """
    touch ${orthoani_result}.tsv

    """
}

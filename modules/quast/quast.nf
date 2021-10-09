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

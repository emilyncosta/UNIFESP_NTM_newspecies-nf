process CLJ_ORTHOANI_PROCESSRESULTS {
    label 'process_low'


    //FIXME Publish babashka binary in a conda channel
    //conda "bioconda::snippy=4.6.0 bioconda::snp-sites=2.5.1"

    //NOTE: Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "BABASHKA module does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://babashka/babashka:1.3.181':
        'docker.io/babashka/babashka:1.3.181' }"

    
    input:
    path("orthoani_results/*")


    output:
    path("*csv")


    script:

    """
    orthoani_refineresults.bb.clj csv -i orthoani_results -o orthoani.results.csv

    """
}

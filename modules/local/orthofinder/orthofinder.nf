process ORTHOFINDER {
    label 'process_medium'

    conda "bioconda::orthofinder=2.5.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/orthofinder:2.5.5--hdfd78af_1' :
        'biocontainers/orthofinder:2.5.5--hdfd78af_1' }"

    input:
    path("fastas/*")

//    output:
//    path('*result.txt')
//    path "versions.yml"           , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """
    orthofinder ${args} -f fastas

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthofinder: 2.5.5.2
    END_VERSIONS
    """

}

process ORTHOFINDER {
    label 'process_medium'

    conda "bioconda::java-jdk=8.0.112 bioconda::blast=2.14.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://docker.io/davidemms/orthofinder:2.5.5.2':
        'docker.io/davidemms/orthofinder:2.5.5.2' }"

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

process ORTHOFINDER {
    label 'process_medium'

    conda "bioconda::orthofinder=2.5.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/orthofinder:2.5.5--hdfd78af_1' :
        'biocontainers/orthofinder:2.5.5--hdfd78af_1' }"

    input:
    path("fastas/*")

    output:
    path('Results*')
    path "versions.yml"           , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """
    orthofinder ${args} -f fastas

    mv fastas/OrthoFinder/Results* .

    rm -rf Results*/WorkingDirectory

    mv Results* orthofinder

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthofinder: \$(orthofinder -h  | grep 'version' | sed 's/^.*OrthoFinder version //' | sed 's/ Copyright (C) 2014 David Emms//')
    END_VERSIONS
    """

}

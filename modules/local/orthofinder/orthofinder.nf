process ORTHOFINDER {
    tag "$fasta1 - $fasta2"
    label 'process_medium'

    conda "bioconda::java-jdk=8.0.112 bioconda::blast=2.14.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/java-jdk:8.0.112--1':
        'ntm-mterrae-container-1:0.0.1' }"

    input:
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*result.txt')
    path "versions.yml"           , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """
    java -jar ${orthoani_jar} \
        -blastplus_dir /opt/conda/bin/ \
        -fasta1 ${fasta1} \
        -fasta2 ${fasta2} \
    > ${fasta1}_${fasta2}.txt

    cat ${fasta1}_${fasta2}.txt  | grep 'OrthoANI' > ${fasta1}_${fasta2}.result.txt

    echo ${fasta1} >>  ${fasta1}_${fasta2}.result.txt
    echo ${fasta2} >>  ${fasta1}_${fasta2}.result.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthoani: 1.40
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    
    """
    touch ${fasta1}_${fasta2}.result.txt
    touch ${fasta2}_${fasta1}.result.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthoani: \$(echo \$(java -jar OAT_cmd.jar  2>&1) | grep "CALCULATOR" | sed "s/.*CALCULATOR //" | sed "s/\]//")
    END_VERSIONS
    """
}

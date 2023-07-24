process ORTHOANI {
    tag '$bam'
    label 'process_medium'

    conda "bioconda::java-jdk=8.0.112"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/java-jdk:8.0.112--1':
        'biocontainers/java-jdk:8.0.112--1' }"

    input:
    val(blastplus_dir)
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*result.txt')
    path('*txt')
    path "versions.yml"           , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    """

    java -jar ${orthoani_jar} -blastplus_dir ${blastplus_dir} -num_threads ${task.cpus} -fasta1 ${fasta1} -fasta2 ${fasta2} > ${fasta1}_${fasta2}.txt

    cat ${fasta1}_${fasta2}.txt  | grep 'OrthoANI' > ${fasta1}_${fasta2}.result.txt

    echo ${fasta1} >>  ${fasta1}_${fasta2}.result.txt
    echo ${fasta2} >>  ${fasta1}_${fasta2}.result.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthoani: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        orthoani: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """
}

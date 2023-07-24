process ORTHOANI {
    tag "$meta.id"
    label 'process_medium'

    conda "java-jdk=8.0.112"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://azul/zulu-openjdk:8u382':
        'docker.io/azul/zulu-openjdk:8u382' }"

    input:
    val(blastplus_dir)
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*result.txt')
    path('*txt')
    path "versions.yml"           , emit: versions


    input:
    path(orthoani_jar)
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("*.bam"), emit: bam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    java -jar ${orthoani_jar} -blastplus_dir ${blastplus_dir} -num_threads ${task.cpus} -fasta1 ${fasta1} -fasta2 ${fasta2} > ${fasta1}_${fasta2}.txt

    cat ${fasta1}_${fasta2}.txt  | grep 'OrthoANI' > ${fasta1}_${fasta2}.result.txt

    echo ${fasta1} >>  ${fasta1}_${fasta2}.result.txt
    echo ${fasta2} >>  ${fasta1}_${fasta2}.result.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        otrhoani: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        otrhoani: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """
}

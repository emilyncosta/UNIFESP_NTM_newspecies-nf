nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/orthoani"
params.save_mode = 'copy'
params.should_publish = true

//NOTE Requires a conda env for blastp and license issue with OrthoANI
process ORTHOANI {
    tag "${fasta1}_${fasta2}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish
    cpus 4


    input:
    val(blastplus_dir)
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*result.txt')
    path('*txt')


    script:

    """

    java -jar ${orthoani_jar} -blastplus_dir ${blastplus_dir} -num_threads ${task.cpus} -fasta1 ${fasta1} -fasta2 ${fasta2} > ${fasta1}_${fasta2}.txt

    cat ${fasta1}_${fasta2}.txt  | grep 'OrthoANI' > ${fasta1}_${fasta2}.result.txt

    echo ${fasta1} >>  ${fasta1}_${fasta2}.result.txt
    echo ${fasta2} >>  ${fasta1}_${fasta2}.result.txt


    """

    stub:
    """

    echo "java -jar ${orthoani_jar} -blastplus_dir ${blastplus_dir} -fasta1 ${fasta1} -fasta2 ${fasta2} > ${fasta1}_${fasta2}.txt"

    touch ${fasta1}_${fasta2}.result.txt

    """
}

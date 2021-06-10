nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/orthoani"
params.saveMode = 'copy'
params.shouldPublish = true

process ORTHOANI {
    tag "${fasta1}_${fasta2}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    //NOTE Requires a conda env for blastp and license issue with OrthoANI

    input:
    val(blastplus_dir)
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*txt')


    shell:

    '''

    mv !{fasta2} !{fasta2}.fasta

    java -jar !{orthoani_jar} -blastplus_dir !{blastplus_dir} -fasta1 !{fasta1} -fasta2 !{fasta2}.fasta > !{fasta1}_!{fasta}.txt

    cat !{fasta1}_!{fasta2}.txt  | grep 'OrthoANI' > !{fasta1}_!{fasta2}.result.txt

    '''

    stub:
    """
    touch ${fasta1}_${fasta2}.result.txt

    """
}

nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/orthoani"
params.saveMode = 'copy'
params.shouldPublish = true

process ORTHOANI {
    tag "${fasta1Name}_${fasta2Name}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    //NOTE Requires a conda env for blastp and license issue with OrthoANI

    input:
    val(blastplus_dir)
    path(orthoani_jar)
    tuple path(fasta1), path(fasta2)

    output:
    path('*txt')


    shell:
    def fasta1Name = fasta1.split("\\.fasta")[0]
    def fasta2Name = fasta2.split("\\.fna")[0]

    '''

    mv !{fasta2} !{fasta2}.fasta

    java -jar !{orthoani_jar} -blastplus_dir !{blastplus_dir} -fasta1 !{fasta1} -fasta2 !{fasta2}.fasta > !{fasta1Name}_!{fasta2Name}.txt

    cat !{fasta1Name}_!{fasta2Name}.txt  | grep 'OrthoANI' > !{fasta1Name}_!{fasta2Name}.result.txt

    '''

    stub:
    """
    touch !{fasta1Name}_!{fasta2Name}.result.txt

    """
}

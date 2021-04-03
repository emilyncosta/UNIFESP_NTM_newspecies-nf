nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/unicycler"
params.saveMode = 'copy'
params.shouldPublish = true

process UNICYCLER {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    publishDir params.resultsDir, mode: params.saveMode, pattern: "*contigs.fasta", enabled: false

    container 'quay.io/biocontainers/unicycler:0.4.8--py38h8162308_3'
    cpus 8
    memory "15 GB"

    input:
    tuple val(genomeName),  path(genomeReads)

    output:
    tuple val(genomeName), path("*contigs.fasta")
    path("${genomeName}")

    script:

    """
    unicycler  \
    -t ${task.cpus} \
    --keep 0 \
    --short1 ${genomeReads[0]} \
    --short2 ${genomeReads[1]} \
    --out ${genomeName} 

    cp ${genomeName}/assembly.fasta ${genomeName}.contigs.fasta
    """


    stub:
    """
    mkdir ${genomeName}
    touch ${genomeName}.contigs.fasta

    """

}


workflow test {

    input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

    UNICYCLER(input_ch)

}

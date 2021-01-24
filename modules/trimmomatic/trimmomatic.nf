nextflow.enable.dsl= 2


params.saveMode = 'copy'
params.resultsDir = "${params.outdir}/trimmomatic"
params.shouldPublish = true


process TRIMMOMATIC {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/trimmomatic:0.35--6'
    cpus 4
    memory "8 GB"

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("*_{R1,R2}.p.fastq.gz")

    script:

    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    """
    trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
    """
}

workflow test {


input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")


TRIMMOMATIC(input_ch)

}

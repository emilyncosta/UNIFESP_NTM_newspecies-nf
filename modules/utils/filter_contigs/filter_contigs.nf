nextflow.enable.dsl= 2


params.saveMode = 'copy'
params.resultsDir = "${params.outdir}/filter_contigs"
params.shouldPublish = true


process UTILS_FILTER_CONTIGS {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/perl-bioperl:1.7.2--pl526_11'
    cpus 4
    memory "8 GB"

    input:
    tuple val(genomeName), path(contig_fasta)
 

    output:
    path("*filtered.fasta")
 

    script:


    """
    filter_contigs.pl 200 ${contig_fasta} > ${genomeName}.filtered.contigs.fasta

    """
}

workflow test {


input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")


UTILS_FILTER_CONTIGS(input_ch)

}

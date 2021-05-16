nextflow.enable.dsl = 2


params.saveMode = 'copy'
params.resultsDir = "${params.outdir}/filter_contigs"
params.shouldPublish = true


process UTILS_FILTER_CONTIGS {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), path(contig_fasta)


    output:
    path("*filtered.fasta")


    script:

    """
    filter_contigs.pl 200 ${contig_fasta} > ${genomeName}.filtered.fasta

    """

    stub:
    """
    echo "filter_contigs.pl 200 ${contig_fasta} > ${genomeName}.filtered.fasta"

    touch ${genomeName}.filtered.fasta
    """
}

workflow test {


    input_ch = Channel.of(["123_S4_L001", "${launchDir}/test_data/123_S4_L001.fasta"],
            ["340_S6_L001", "${launchDir}/test_data/340_S6_L001.fasta"])
    UTILS_FILTER_CONTIGS(input_ch)


}

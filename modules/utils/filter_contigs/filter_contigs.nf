nextflow.enable.dsl = 2


params.save_mode = 'copy'
params.results_dir = "${params.outdir}/filter_contigs"
params.should_publish = true


process UTILS_FILTER_CONTIGS {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

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

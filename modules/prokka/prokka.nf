nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/prokka"
params.saveMode = 'copy'
params.shouldPublish = true

process PROKKA {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/prokka:1.14.6--pl526_0'
    cpus 8
    memory "15 GB"

    input:
    tuple val(genomeName),  path(bestContig)

    output:
    path("${genomeName}")

    script:

    """
    prokka --outdir ${genomeName} --prefix $genomeName ${bestContig} --cpus ${task.cpus}
    """

}


workflow test {

input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

params.SPADES = [
	shouldPublish: false
]

include { SPADES } from "../spades/spades.nf" addParams( params.SPADES )

SPADES(input_ch)

PROKKA(SPADES.out)


}

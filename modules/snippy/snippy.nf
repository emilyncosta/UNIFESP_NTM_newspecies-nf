nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/snippy"
params.saveMode = 'copy'
params.shouldPublish = true

process SNIPPY {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/snippy:4.6.0--0'

    input:
    tuple val(genomeName),  path(genomeReads)
    path(refGbk)

    output:
    path("${genomeName}")

    script:
    ram = "${task.memory}".split(" ")[0]

    """

    snippy --cpus ${task.cpus} --ram ${ram} --outdir $genomeName --ref $refGbk --R1 ${genomeReads[0]} --R2 ${genomeReads[1]}

    """

    stub:
    ram = "${task.memory}".split(" ")[0]
    """
    echo "snippy --cpus ${task.cpus} --ram ${ram} --outdir $genomeName --ref $refGbk --R1 ${genomeReads[0]} --R2 ${genomeReads[1]}"

    mkdir ${genomeName}

    """
}

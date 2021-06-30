nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/snippy"
params.save_mode = 'copy'
params.should_publish = true

process SNIPPY {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)
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

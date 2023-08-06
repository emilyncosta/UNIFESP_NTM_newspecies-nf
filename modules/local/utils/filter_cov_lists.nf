process UTILS_FILTER_COV_LISTS {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::spades=3.15.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/spades:3.15.5--h95f258a_1' :
        'biocontainers/spades:3.15.5--h95f258a_1' }"

    input:
    tuple val(meta), path(contigsgz)

    output:
    tuple val(meta), path('*.LCov.contigs.list'), path('*.HCov.contigs.list')      , optional:true, emit: contigs
    path  "versions.yml"                                                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args_lcov = task.ext.args_lcov
    def args_hcov = task.ext.args_hcov
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    gunzip ${contigsgz}

    grep -F ">" *contigs.fa | sed -e 's/_/ /g' | sort -nrk 6 | awk '${args_lcov} {print \$0}'  | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.LCov.contigs.list
    grep -F ">" *contigs.fa |  sed -e 's/_/ /g' | sort -nrk 6 | awk '${args_hcov} {print \$0}' | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.HCov.contigs.list

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        grep: v1.32.1 (BusyBox)
    END_VERSIONS
    """
}

process UTILS_FILTER_COV_LISTS {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::multiqc=1.14"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/multiqc:1.14--pyhdfd78af_0' :
        'quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(contigsgz)

    output:
    tuple val(meta), path("*.contigs.fa"), path('*.LCov.contigs.list'), path('*.HCov.contigs.list')      , optional:true, emit: contigs_lists
    path  "versions.yml"                                                                                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args_lcov = task.ext.args_lcov
    def args_hcov = task.ext.args_hcov
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    gunzip -f ${contigsgz}

    grep -F ">" *contigs.fa | sed -e 's/_/ /g' | sort -nrk 6 | awk '${args_lcov} {print \$0}'  | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.LCov.contigs.list
    grep -F ">" *contigs.fa |  sed -e 's/_/ /g' | sort -nrk 6 | awk '${args_hcov} {print \$0}' | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.HCov.contigs.list

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        grep: v1.32.1 (BusyBox)
    END_VERSIONS
    """
}

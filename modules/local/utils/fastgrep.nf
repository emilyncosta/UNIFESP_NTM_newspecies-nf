process UTILS_FASTGREP {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::perl-bioperl=1.7.8"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/perl-bioperl:1.7.8--hdfd78af_1' :
        'biocontainers/perl-bioperl:1.7.8--hdfd78af_1' }"

    input:
    tuple val(meta), path(contig), path(lcov_contigs), path(hcov_contigs)

    output:
//    tuple val(meta), path('*.LCov.contigs.list'), path('*.HCov.contigs.list')      , optional:true, emit: contigs_lists
    path  "versions.yml"                                                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    fastgrep.pl -f ${hcov_contigs} ${contig} > ${prefix}.fna

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl --version | grep 'This is perl' | sed 's/.*(v//g' | sed 's/)//g')
    END_VERSIONS
    """
}

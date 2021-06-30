nextflow.enable.dsl = 2


params.results_dir = "${params.outdir}/spades"
params.should_publish = true
params.save_mode = 'copy'

process SPADES {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("*_contigs.fasta")


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}
    cp ${genomeName}/contigs.fasta ${genomeName}_contigs.fasta
    """

    stub:
    """
    echo  "spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}"

    mkdir ${genomeName}
    touch ${genomeName}/${genomeName}_contigs.fasta
    """
}


workflow test {

    params.TRIMMOMATIC = [
            shouldPublish: false
    ]


    include { TRIMMOMATIC } from "../trimmomatic/trimmomatic.nf" addParams(params.TRIMMOMATIC)

    input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

    TRIMMOMATIC(input_ch)

    SPADES(TRIMMOMATIC.out)


}

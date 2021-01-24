nextflow.enable.dsl = 2

include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { UNICYCLER } from "./modules/unicycler/unicycler.nf"
include { FASTQC } from "./modules/fastqc/fastqc.nf"

// TODO
//include { SNIPPY } from "./modules/snippy/snippy.nf"


workflow {

    sra_ch = Channel.fromFilePairs(params.reads)

    TRIMMOMATIC(sra_ch)
    FASTQC(TRIMMOMATIC.out)
    UNICYCLER(TRIMMOMATIC.out)
    SPADES(TRIMMOMATIC.out)
    PROKKA(SPADES.out)

    //TODO
    // SNIPPY()
}



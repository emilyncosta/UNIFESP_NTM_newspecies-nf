nextflow.enable.dsl = 2

include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { UNICYCLER } from "./modules/unicycler/unicycler.nf"
include { FASTQC as FASTQC_UNTRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc_untrimmed")
include { FASTQC as FASTQC_TRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc_trimmed")

// TODO
//include { SNIPPY } from "./modules/snippy/snippy.nf"


workflow {

    sra_ch = Channel.fromFilePairs(params.reads)

    FASTQC_UNTRIMMED(sra_ch)
    TRIMMOMATIC(sra_ch)
    FASTQC_TRIMMED(TRIMMOMATIC.out)
    UNICYCLER(TRIMMOMATIC.out)
    SPADES(TRIMMOMATIC.out)
    PROKKA(SPADES.out)

    //TODO
    // SNIPPY()
}



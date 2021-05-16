nextflow.enable.dsl = 2

include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { QUAST } from "./modules/quast/quast.nf"
include { UNICYCLER } from "./modules/unicycler/unicycler.nf"
include { FASTQC as FASTQC_UNTRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc_untrimmed")
include { FASTQC as FASTQC_TRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc_trimmed")
include { MULTIQC as MULTIQC_TRIMMED } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc_trimmed", fastqcResultsDir: "${params.outdir}/fastqc_trimmed")
include { MULTIQC as MULTIQC_UNTRIMMED } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc_untrimmed", fastqcResultsDir: "${params.outdir}/fastqc_untrimmed")
include { UTILS_FILTER_CONTIGS } from "./modules/utils/filter_contigs/filter_contigs.nf"
include { SNIPPY } from "./modules/snippy/snippy.nf"


workflow {

    sra_ch = Channel.fromFilePairs(params.reads)
    refGbk_ch = Channel.value(java.nio.file.Paths.get(params.gbkFile))

    FASTQC_UNTRIMMED(sra_ch)
    MULTIQC_UNTRIMMED(FASTQC_UNTRIMMED.out.flatten().collect())

    TRIMMOMATIC(sra_ch)
    FASTQC_TRIMMED(TRIMMOMATIC.out)
    MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())

    UNICYCLER(TRIMMOMATIC.out)
    UTILS_FILTER_CONTIGS(UNICYCLER.out[0])
    QUAST(UTILS_FILTER_CONTIGS.out.collect(), refGbk_ch)

    PROKKA(UNICYCLER.out[0], refGbk_ch)

    SNIPPY(TRIMMOMATIC.out, refGbk_ch)
    

}



// TODO: We can extract this workflow to generalize it as a standard workflow
workflow QUALITY_CHECK_WF {

    sra_ch = Channel.fromFilePairs(params.reads)

    FASTQC_UNTRIMMED(sra_ch)
    MULTIQC_UNTRIMMED(FASTQC_UNTRIMMED.out.flatten().collect())

    TRIMMOMATIC(sra_ch)
    FASTQC_TRIMMED(TRIMMOMATIC.out)
    MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())


}

// NOTE: By 16-05-2021 we have decided to rely upon Spades, due to Edson's experience
// with Unicycler.
workflow SPADES_QUAST_WF {

    sra_ch = Channel.fromFilePairs(params.reads)
    refGbk_ch = Channel.value(java.nio.file.Paths.get(params.gbkFile))

    TRIMMOMATIC(sra_ch)
    SPADES(TRIMMOMATIC.out)
    UTILS_FILTER_CONTIGS(SPADES.out)
    QUAST(UTILS_FILTER_CONTIGS.out.collect(), refGbk_ch)

    PROKKA(SPADES.out[0], refGbk_ch)

}


workflow TEMP_WF {

    sra_ch = Channel.fromFilePairs(params.reads)

    TRIMMOMATIC(sra_ch)
    
}





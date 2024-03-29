/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)

// Validate input parameters
WorkflowNtm_newspecies_nf.initialise(params, log)

// TODO nf-core: Add all file path parameters for the pipeline to the list below
// Check input path parameters to see if they exist
def checkPathParamList = [ params.input, params.multiqc_config, params.fasta ]
for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }

// Check mandatory parameters
if (params.input) { ch_input = file(params.input) } else { exit 1, 'Input samplesheet not specified!' }

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

ch_multiqc_config          = Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)
ch_multiqc_custom_config   = params.multiqc_config ? Channel.fromPath( params.multiqc_config, checkIfExists: true ) : Channel.empty()
ch_multiqc_logo            = params.multiqc_logo   ? Channel.fromPath( params.multiqc_logo, checkIfExists: true ) : Channel.empty()
ch_multiqc_custom_methods_description = params.multiqc_methods_description ? file(params.multiqc_methods_description, checkIfExists: true) : file("$projectDir/assets/methods_description_template.yml", checkIfExists: true)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
include { INPUT_CHECK } from '../subworkflows/local/input_check'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { CHECKM_LINEAGEWF                  } from '../modules/nf-core/checkm/lineagewf/main'
include { TRIMMOMATIC                       } from '../modules/nf-core/trimmomatic/main'
include { SPADES                            } from '../modules/nf-core/spades/main'
include { RAXMLNG as RAXMLNG_NO_BOOTSTRAP   } from '../modules/nf-core/raxmlng/main'
include { RAXMLNG as RAXMLNG_BOOTSTRAP      } from '../modules/nf-core/raxmlng/main'
include { FASTQC                            } from '../modules/nf-core/fastqc/main'
include { MULTIQC                           } from '../modules/nf-core/multiqc/main'
include { CUSTOM_DUMPSOFTWAREVERSIONS       } from '../modules/nf-core/custom/dumpsoftwareversions/main'
include { UTILS_FILTER_COV_LISTS            } from '../modules/local/utils/filter_cov_lists.nf'
include { UTILS_FASTGREP                    } from '../modules/local/utils/fastgrep.nf'

include { KRAKEN2_KRAKEN2 as CLASSIFY_KRAKEN2 } from '../modules/nf-core/kraken2/kraken2/main'                                                              

include { ORTHOANI                          } from '../modules/local/orthoani/orthoani.nf'
include { CLJ_ORTHOANI_PROCESSRESULTS       } from '../modules/local/orthoani/processresults.nf'
include { ORTHOFINDER                       } from '../modules/local/orthofinder/orthofinder.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Info required for completion email and summary
def multiqc_report = []

workflow NTM_NEWSPECIES_NF {



if (params.compute_similarity_wf) {

    fasta_ch = Channel.fromPath("${params.orthoani_fastas}")

    ORTHOFINDER ( fasta_ch.collect() )

    ch_in_orthoani = fasta_ch.combine(fasta_ch).filter { a,b -> a != b }
    ORTHOANI (params.orthoani_jar, ch_in_orthoani)

    CLJ_ORTHOANI_PROCESSRESULTS(ORTHOANI.out.result.collect(sort:true))

}

if (params.generate_assemblies_wf) {

    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //
    INPUT_CHECK (
        ch_input
    )
    ch_versions = ch_versions.mix(INPUT_CHECK.out.versions)

    //
    // MODULE: Run FastQC
    //
    FASTQC (
        INPUT_CHECK.out.reads
    )
    ch_versions = ch_versions.mix(FASTQC.out.versions.first())

//==================================
//NTM_NEWSPECIES_NF
//==================================

//NOTE: Assumed to be downloaded from https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20231009.tar.gz

    CLASSIFY_KRAKEN2 (
        INPUT_CHECK.out.reads,
        params.kraken2_db,
        true,
        true
    )

    TRIMMOMATIC (
        INPUT_CHECK.out.reads,
        params.adapter
    )
    ch_versions = ch_versions.mix(TRIMMOMATIC.out.versions.first())

    ch_in_spades = TRIMMOMATIC.out.trimmed_reads
                        .map { m,f -> [m,f,[],[]]}
                        //.debug(tag:'ch_in_spades')

    SPADES (
        ch_in_spades,
        [],
        []
    )

    ch_versions = ch_versions.mix(SPADES.out.versions.first())


    UTILS_FILTER_COV_LISTS ( SPADES.out.contigs )
    ch_versions = ch_versions.mix(UTILS_FILTER_COV_LISTS.out.versions.first())

    UTILS_FASTGREP ( UTILS_FILTER_COV_LISTS.out.contigs_lists )
    ch_versions = ch_versions.mix(UTILS_FASTGREP.out.versions.first())

//NOTE: Maybe just better to rely upon nf-core/mag for this?
//    CHECKM_LINEAGEWF ( UTILS_FASTGREP.out.hcov_fasta, 'fasta', [] )
//    ch_versions = ch_versions.mix( CHECKM_LINEAGEWF.out.versions.first() )


//FIXME The raxmlng execution is a bit problematic
//    ch_in_raxmlng = UTILS_FASTGREP.out.hcov_fasta.map { m, f -> f } 
//    RAXMLNG_NO_BOOTSTRAP ( ch_in_raxmlng )
//    RAXMLNG_BOOTSTRAP ( ch_in_raxmlng )
    

//==================================
//==================================

    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )


    //
    // MODULE: MultiQC
    //
    workflow_summary    = WorkflowNtm_newspecies_nf.paramsSummaryMultiqc(workflow, summary_params)
    ch_workflow_summary = Channel.value(workflow_summary)

    methods_description    = WorkflowNtm_newspecies_nf.methodsDescriptionText(workflow, ch_multiqc_custom_methods_description)
    ch_methods_description = Channel.value(methods_description)

    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(ch_workflow_summary.collectFile(name: 'workflow_summary_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(ch_methods_description.collectFile(name: 'methods_description_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml.collect())
    ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]}.ifEmpty([]))

    MULTIQC (
        ch_multiqc_files.collect(),
        ch_multiqc_config.toList(),
        ch_multiqc_custom_config.toList(),
        ch_multiqc_logo.toList()
    )
    multiqc_report = MULTIQC.out.report.toList()

 }


}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    COMPLETION EMAIL AND SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
    }
    NfcoreTemplate.summary(workflow, params, log)
    if (params.hook_url) {
        NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

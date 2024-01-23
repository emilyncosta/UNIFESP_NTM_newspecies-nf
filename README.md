[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.8220379?labelColor=000000)](https://doi.org/10.5281/zenodo.8220379)


[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Nextflow Tower](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Nextflow%20Tower-%234256e7)](https://tower.nf/launch?pipeline=https://github.com/UNIFESP_LABMICOBACT/ntm_mterrae_nf)

## Introduction

**UNIFESP_ntm_newspecies_nf** is a bioinformatics pipeline used for the paper entitled [Description of new species of Mycobacterium terrae complex isolated from sewage at the São Paulo Zoological Park Foundation in Brazil](https://doi.org/10.3389/fmicb.2024.1335985)


## IDs for the submitted FASTQ samples

| Sample ID |  ATCC ID | JCM ID |        Nomenclature       | Nomenclature alias (Gupta et a. 2018) | GenBanK 16S rRNA gene |  Bioproject |   Biosample  |     SRA     | GenBank Draft Genome | PGAP Annotation |
|:---------:|:--------:|:------:|:-------------------------:|:-------------------------------------:|:---------------------:|:-----------:|:------------:|:-----------:|:--------------------:|:---------------:|
| MYC017    | TSD-296T | 35364T | Mycobacterium vasticus    | Mycolicibacter vasticus               | MK890459.1            | PRJNA755977 | SAMN20959233 | SRR27405758 | CP084028             | JAYJJQ000000000 |
| MYC098    | TSD-297T | 35365T | Mycobacterium crassicus   | Mycolicibacter crassicus              | MK890478.1            | PRJNA757362 | SAMN20959234 | SRR27405950 | CP084029             | JAYJJR000000000 |
| MYC101    | TSD-298T | 35366T | Mycobacterium zoologicum  | Mycolicibacter zoologicum             | MK890479.1            | PRJNA757364 | SAMN20959235 | SRR27405954 | CP084030             | JAYJJS000000000 |
| MYC123    | BAA3216  | 35367  | Mycobacterium zoologicum  | Mycolicibacter zoologicum             | MK890481.1            | PRJNA743883 | SAMN20062777 | SRR27406169 | CP083985             | JAYJJT000000000 |
| MYC340    | TSD-299T | 35368T | Mycobacterium nativiensis | Mycolicibacter nativiensis            | MK890521.1            | PRJNA743885 | SAMN20062778 | SRR27406220 | CP083986             | JAYJJU000000000 |

## Usage

> **Note**
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how
> to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline)
> with `-profile test` before running the workflow on actual data.

<!-- TODO nf-core: Describe the minimum required steps to execute the pipeline, e.g. how to prepare samplesheets.
     Explain what rows and columns represent. For instance (please edit as appropriate):

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_1,fastq_2
CONTROL_REP1,AEG588A1_S1_L002_R1_001.fastq.gz,AEG588A1_S1_L002_R2_001.fastq.gz
```

Each row represents a fastq file (single-end) or a pair of fastq files (paired end).

-->

Now, you can run the pipeline using:

<!-- TODO nf-core: update the following command to include all required parameters for a minimal example -->

```bash
nextflow run emilyncosta/UNIFESP_ntm_newspecies_nf \
   -profile docker \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

> **Warning:**
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those
> provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_;
> see [docs](https://nf-co.re/usage/configuration#custom-configuration-files).

## Credits

UNIFESP_LABMICOBACT/ntm_mterrae_nf was originally written by Abhinav Sharma (@abhi18av).

We thank the following people for their extensive assistance in the development of this pipeline: 
Luciano Antonio Digiampietri (@digiampietri), Edson Filho Machado Silvia (@edsonmachado) and Emilyn Costa Conceicao (@emilyncosta)

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use  UNIFESP_LABMICOBACT/ntm_mterrae_nf for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

<!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

This pipeline is part of the following study: Romagnoli et al. 2024. Description of new species of Mycobacterium terrae complex isolated from sewage at the São Paulo Zoological Park Foundation in Brazil https://www.frontiersin.org/articles/10.3389/fmicb.2024.1335985 

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).

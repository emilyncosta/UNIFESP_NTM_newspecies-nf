# camila_sao_paulo nextflow pipeline
A pipeline for Genome Assembly, Genome Anotation and Variant Calling with quality evaluation, using .fastq files and a reference genome as input.

## Minimal requirements (for local execution)

* Nextflow VERSION > 20.11
* Java 8
* Docker

## Pipeline workflow

![dag file](./resources/dag.png)

This is the complete workflow of this pipeline, the tool integration aims on a good quality evaluation of all process, 

## Quick start

### Local execution
1. Install nextflow 

	Please refer to [Nextflow page on github](https://github.com/nextflow-io/nextflow/) for more info.

2. Run it!

```
	nextflow run https://github.com/bioinformatics-lab/camila_sao_paulo_nf.git --reads $READ --gbkFile $GBK --outdir $OUTDIR

```

$READ = STR, replace for your reads location. You can write using READ_{1,2}.fastq.gz or READ_1.fastq.gz READ_2.fastq.gz 

$GBK = STR, replace for your reference gbk lcation.

$OUDIR = STR, replace for the name of your desired output directory.

## Configuration Profiles.

You can use diferent profiles for this pipeline, based on the computation enviroment at your disposal. Here are the Avaliable Profiles:

* aws 

* gls

* azureBatch

* awsBatch

`Note: Update conf/profile with your own credentials`

## Tower execution
This Pipeline can be launched on `Tower`, please refer to [Tower launch documentation](https://help.tower.nf/docs/launch/overview/) for step-by-step execution tutorial.

When launching from `Tower`, please update and use the `params.yml` file contents.

## stub-run
This project has the `-stub-run` feature, that can be used for testing propouse, it can be used on `Tower` with the Advanced settings on launch. You can also test it locally, using the following command:

```
bash data/mock_data/generate_mock_data.sh
nextflow run main.nf \
		 -params-file stub_params.yaml \
		 -stub-run
``` 

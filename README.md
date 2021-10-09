# camila_sao_paulo nextflow pipeline
A pipeline for Genome Assembly, Genome Anotation and Variant Calling with quality evaluation, using `.fastq` files and a reference genome as input.

## Minimal requirements (for local execution)

* Nextflow 
* Java
* Docker

## Quick start

### Local execution
1. Install nextflow 

	Please refer to [Nextflow page on github](https://github.com/nextflow-io/nextflow/) for more info.

2. Clone it 


```shell
git clone https://github.com/emilyncosta/labmicobact_unifesp_ntm_romagnoli_nf
```

3. Run it!

Please update the `params/local.yml` file before using it in local execution.

```
nextflow run main.nf -params-file params/local.yml 
```


## Configuration Profiles.

You can use diferent profiles for this pipeline, based on the computation enviroment at your disposal. Here are the Avaliable Profiles in `conf/` folder.

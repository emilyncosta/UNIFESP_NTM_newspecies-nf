#/usr/bin/env pwsh

# Author: @abhi18av
# Script to address the task https://app.clickup.com/t/862k5zzcf

$final_assemblies = @("GCA_000069185.1",
"GCF_002102055.1",
"GCF_002086715.1",
"GCF_001044245.1",
"GCF_001307545.1",
"GCF_004721035.1",
"GCF_002104795.1",
"GCF_002102395.1",
"GCF_000157895.3",
"GCF_000195955.2",
"GCF_000014985.1",
"GCF_018455725.1",
"GCF_002086455.1",
"GCF_002086515.1",
"GCF_002101585.1",
"GCF_001021505.1",
"GCF_002101655.1",
"GCF_900078685.1",
"GCF_002086285.1",
"GCF_002102265.1",
"GCF_002086405.1",
"GCF_002101775.1",
"GCF_022430545.2",
"GCF_002101885.1",
"GCF_000214155.1",
"GCF_002101955.1",
"GCF_002967035.1"
)


foreach( $assembly in $final_assemblies) {


    conda run -n ntm-mterrae-env datasets download genome accession $assembly --include genome --filename "$assembly.zip"

    ouch d "$assembly.zip" --quiet

    $name = $assembly.split(".")[0]
    cp $name/ncbi_dataset/data/$assembly/*fna "$assembly.fa"
    rm -rf $name

  }



rm -rf *zip

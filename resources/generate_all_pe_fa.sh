#!/usr/bin/env bash

set -uex

wget https://github.com/usadellab/Trimmomatic/raw/V0.39/adapters/NexteraPE-PE.fa

wget https://github.com/usadellab/Trimmomatic/raw/V0.39/adapters/TruSeq2-PE.fa

wget https://github.com/usadellab/Trimmomatic/raw/V0.39/adapters/TruSeq3-PE.fa

cat NexteraPE-PE.fa TruSeq2-PE.fa  TruSeq3-PE.fa > ALL_PE.fa

#!/bin/bash
conda create -n trimgalore_env -c bioconda -c conda-forge -c anacond trim-galore
conda install -c bioconda kraken2
wget https://genome-idx.s3.amazonaws.com/kraken/minikraken2_v2_8GB_201904.tgz
tar -xvzf minikraken2_v2_8GB_201904.tgz
unzip Bracken-2.7.zip
cd Bracken-2.7/
bash install_bracken.sh
cd ..
conda install -c bioconda krona
ln -s anaconda/opt/krona/taxonomy anaconda/bin/taxonomy
ktUpdateTaxonomy.sh
echo "Installation complete; Proceed with your analysis"

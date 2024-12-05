#!/bin/bash
read -p "Please Enter Path: " r1
read -p "Please Enter read length: " l1
read -p "Please Enter number of threads to use: " t1
teams=()
while read -r line
do
export PATH="$r1":$PATH
source activate trimgalore_env
teams+=("$line")
trim_galore --fastqc --paired "$line"_R1.fastq.gz "$line"_R2.fastq.gz
rename _val_1.fq.gz trimmed.fq.gz *
rename _val_2.fq.gz trimmed.fq.gz *
conda deactivate
conda run kraken2 --use-names --threads 4 --db minikraken2_v2_8GB_201904"/"minikraken2_v2_8GB_201904_UPDATE --fastq-input --report "$line".report --gzip-compressed --paired "$line"_R1trimmed.fq.gz "$line"_R2trimmed.fq.gz > "$line".kraken
bash Bracken-2.7"/"bracken -d minikraken2_v2_8GB_201904"/"minikraken2_v2_8GB_201904_UPDATE -i "$line".report -o "$line".bracken -r $l1 -t $t1
done <list.txt
conda run ktImportTaxonomy -t 5 -m 3 -o krona.html *.report
python Bracken-2.7"/"analysis_scripts"/"combine_bracken_outputs.py --files *.bracken -o combined_bracken
mkdir QC Bracken_result Kraken_result
mv *_report.txt *trimmed.fq.gz *fastqc.html *.zip QC
mv *_bracken_species.report *.bracken Bracken_result
mv *.report *.kraken Kraken_result

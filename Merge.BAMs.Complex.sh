#!/bin/bash
##################################################################
# AIM : to make a slurm script for samtools merge tool to merge M3M4 bam files
# Input:sorted and filtered and STAR bam files, txt files giving list of input replicate BAM files to be merged (one replicate per line)
# Ouput: single bam file per replicate group
# Author: Marilyn Seyfi
# email: seyfim@ccf.org
# Date: 31 Mar 2018
################################################################
#------------------------- modify here -------------------
# Dirs
bam_dir="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/Ensembl-Alignment/filtered-and-indexed_BAMs"
dummies="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/Ensembl-Alignment/DummyFiles"
output_loc="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/Ensembl-Alignment/filtered-and-indexed_BAMs/Merged"

# Pattern in fastq | fastq.gz
bam_pat="/*.bam"
# slurm script
res_script1="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/ggsashimi/scripts/run_samtoolsMergeEns_P40_gmi.sh"
res_script2="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/ggsashimi/scripts/run_samtoolsMergeEns_P14_gmi.sh"
#----------------------------------------------------------

touch $res_script1
echo "#!/bin/bash

module load python/2.7.12
module load samtools/current

" >>$res_script1
touch $res_script2
echo "#!/bin/bash

module load python/2.7.12
module load samtools/current

" >>$res_script2
for i in `ls $dummies$bam_pat`;do
    if [[ $i = *"P40"* ]];then
        bn=$(basename "$i")
        bn=${bn%-1*}
        if [[ $bn =~ "P40Wt" ]];then
            in_bama="$bam_dir"/"$bn"-4.sorted.filtered.bam""
            in_bamb="$bam_dir"/"$bn"-5.sorted.filtered.bam""
            in_bamc="$bam_dir"/"$bn"-6.sorted.filtered.bam""
            out_bam1="$output_loc"/"$bn"_merged.bam""
        else
            in_bama="$bam_dir"/"$bn"-1.sorted.filtered.bam""
            in_bamb="$bam_dir"/"$bn"-4.sorted.filtered.bam""
            in_bamc="$bam_dir"/"$bn"-5.sorted.filtered.bam""
            out_bam1="$output_loc"/"$bn"_merged.bam""
        fi
        echo "samtools merge -@ 28 $out_bam1 $in_bama $in_bamb $in_bamc">>$res_script1

    else
        bn=$(basename "$i")
        bn=${bn%-1*}
        in_bame="$bam_dir"/"$bn"-1.sorted.filtered.bam""
        in_bamf="$bam_dir"/"$bn"-2.sorted.filtered.bam""
        in_bamg="$bam_dir"/"$bn"-3.sorted.filtered.bam""
        out_bam2="$output_loc"/"$bn"_merged.bam""
    echo "samtools merge -@ 28 $out_bam2 $in_bame $in_bamf $in_bamg">>$res_script2
    fi
done

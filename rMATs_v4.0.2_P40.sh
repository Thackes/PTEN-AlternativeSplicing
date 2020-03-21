#!/usr/bin/env bash
##################################################################
# AIM : to make a slurm script for rMATS 4.0.2 to run on replicate, sorted and indexed M3M4 bam files
# Input:sorted and filtered and STAR bam files, mm10 gencode gtf file (gencode.vM16.annotation.gtf)
# Ouput:slurm script that will create a directory containing files of AS analysis performed by rMATS, specifically the MATS_OUTPUT subdirectory that contains the delta
# psi values per splicing event per gene
# Author: Marilyn Seyfi
# email: seyfim@ccf.org
# Date: 11 Dec 2019
################################################################
#------------------------- modify here -------------------
# Dirs
export bam_dir="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/STAR_filtered_and_indexed_bam"
export gtf_loc="/home/seyfim/isilon/NGS_Working/Library_Files/Genome/Mouse/mm10/gencode/gencode.vM16.annotation.gtf"
export output_loc="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2"

export H1="${bam_dir}/P40M3M4HetM1cortexAligned.filtered.bam"
export H2="${bam_dir}/P40M3M4HetM4cortexAligned.filtered.bam"
export H3="${bam_dir}/P40M3M4HetM5cortexAligned.filtered.bam"
export M1="${bam_dir}/P40M3M4MutM1cortexAligned.filtered.bam"
export M2="${bam_dir}/P40M3M4MutM4cortexAligned.filtered.bam"
export M3="${bam_dir}/P40M3M4MutM5cortexAligned.filtered.bam"
export W1="${bam_dir}/P40M3M4WtM1cortexAligned.filtered.bam"
export W2="${bam_dir}/P40M3M4WtM4cortexAligned.filtered.bam"
export W3="${bam_dir}/P40M3M4WtM5cortexAligned.filtered.bam"

echo "${W1},${W2},${W3}">> wt_P40.txt
echo "${H1},${H2},${H3}" >> het_P40.txt
echo "${M1},${M2},${M3}" >> mut_P40.txt

export WT="wt_P40.txt"
export MUT="mut_P40.txt"
export HET="het_P40.txt"

#----------------------------------------------------------

module load python/2.7.12
module load samtools/0.1.19
module load STAR/2.5.4b
module load rMATS/4.0.2

/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${WT}  --b2 ${HET}  --gtf ${gtf_loc} --od ${output_loc}/WtMut -t paired --nthread 28 --readLength 100 --libType fr-secondstrand
/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${WT} --b2 ${MUT} --gtf $gtf_loc --od $output_loc/WtHet -t paired --nthread 28 --readLength 100 --libType fr-secondstrand
/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${MUT} --b2 ${HET} --gtf $gtf_loc --od $output_loc/MutHet -t paired --nthread 28 --readLength 100 --libType fr-secondstrand

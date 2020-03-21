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

export H1="${bam_dir}/P14M3M4HetM1brainAligned.filtered.bam"
export H2="${bam_dir}/P14M3M4HetM2brainAligned.filtered.bam"
export H3="${bam_dir}/P14M3M4HetM3brainAligned.filtered.bam"
export M1="${bam_dir}/P14M3M4MutM1brainAligned.filtered.bam"
export M2="${bam_dir}/P14M3M4MutM2brainAligned.filtered.bam"
export M3="${bam_dir}/P14M3M4MutM3brainAligned.filtered.bam"
export W1="${bam_dir}/P14M3M4WtM1brainAligned.filtered.bam"
export W2="${bam_dir}/P14M3M4WtM2brainAligned.filtered.bam"
export W3="${bam_dir}/P14M3M4WtM3brainAligned.filtered.bam"



echo "${W1},${W2},${W3}" >> wt_P14.txt
echo "${H1},${H2},${H3}" >> het_P14.txt
echo "${M1},${M2},${M3}" >> mut_P14.txt

export WT="wt_P14.txt"
export MUT="mut_P14.txt"
export HET="het_P14.txt"

#----------------------------------------------------------

module load python/2.7.12
module load samtools/0.1.19
module load STAR/2.5.4b
module load rMATS/4.0.2

# /cm/shared/apps/rMATS/4.0.2/rmats.py --b1 p14_MUT.txt --b2 p14_HET.txt --gtf /home/seyfim/isilon/NGS_Working/Library_Files/Genome/Mouse/mm10/gencode/gencode.vM16.annotation.gtf --od /home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2/P14MutHet_output --nthread 20 --readLength 100 --libType fr-secondstrand


/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${WT}  --b2 ${HET}  --gtf ${gtf_loc} --od ${output_loc}/WtMut --nthread 28 --readLength 100 --libType fr-secondstrand
/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${WT} --b2 ${MUT} --gtf $gtf_loc --od $output_loc/WtHet  --nthread 28 --readLength 100 --libType fr-secondstrand
/cm/shared/apps/rMATS/4.0.2/rmats.py --b1 ${MUT} --b2 ${HET} --gtf $gtf_loc --od $output_loc/MutHet --nthread 28 --readLength 100 --libType fr-secondstrand

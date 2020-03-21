#!/bin/bash
#########################################################################
# AIM : to create a STAR Index for alignment
# Input: genome.fa and .gtf files
# Ouput: directory with needed indexing files for STAR alignment
# Author: Marilyn Seyfi
# email: seyfim@ccf.org
# Date: 28 Feb 2020
#######################################################################
#------------------------- modify here -------------------
export lib_base="/home/seyfim/isilon/NGS_Working/Library_Files/Genome/Human/hg38/gencode"
#genome.fa file
export genome_loc=${lib_base}"/GRCh38.primary_assembly.genome.fa"
#gtf file
export gtf_loc="${lib_base}/gencode.v33.primary_assembly.annotation.gtf"
#STAR index output location
export index_loc="/home/seyfim/isilon/NGS_Working/Lamis_Yehia/Busch_TLE.PreOP.Memory.miRNAseq/data/STAR.Index"

export star="/cm/shared/apps/STAR/2.5.2b/STAR"
#----------------------------------------------------------

${star} --runThreadN 28 --runMode genomeGenerate --genomeDir ${index_loc} --genomeFastaFiles ${genome_loc} --sjdbGTFfile ${gtf_loc} --sjdbOverhang 100

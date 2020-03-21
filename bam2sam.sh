#!/bin/bash
################################################################
# aim: create slurm script to convert bam files to sam files
# input: bam files
# output: sam files
# date: 29 June 2018
# author: Marilyn Seyfi
# email:seyfim@ccf.org
####################################################################
#------------------------- modify here -------------------
# Dirs
bam_dir="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/STAR_filtered_and_indexed_bam/renamed_for_cufflinks"
sam_loc="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/STAR_filtered_and_indexed_sam"

# Pattern of sam file
bam_pat="/*.bam"

# slurm script
res_script="/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/DiffSplice/scripts/all_samtools_bam2sam.sh"
#----------------------------------------------------------
touch $res_script
echo "#!/bin/bash
module load python/2.7.12
module load samtools/current

" >>$res_script

for i in `ls $bam_dir$bam_pat`
        do
        #echo $i
        #echo ''
        bdir=`dirname $i`
        bn=`basename $i | sed s/.bam//`
        in_bam=$bam_dir"/"$bn".bam"
        out_sam=$sam_loc"/"$bn".sam"
        #echo $out_bam
                echo "samtools view -h -o $out_sam $in_bam ">>$res_script

done

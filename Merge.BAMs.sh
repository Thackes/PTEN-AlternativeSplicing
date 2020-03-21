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
rep_bam_dir="/home/thackes/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/STAR_filtered_and_indexed_bam/Merged"
index_SE_events="/home/thackes/lustre/MISO_STAR/data/indexed_SE_events_gencode"
output_loc="/home/thackes/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/fasta_and_bam_files/STAR_filtered_and_indexed_bam/Merged"

# Pattern in fastq | fastq.gz
bam_pat="/*.bam"
ListFile_pat="/*.txt"

# slurm script
res_script="/home/thackes/lustre/MISO_STAR/scripts/run_samtoolsMerge_bam_hpc_2Apr.sh"
#----------------------------------------------------------

touch $res_script
echo "#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thackes@ccf.org
#SBATCH --job-name=samtools_Merge
#SBATCH --partition=gmi
#SBATCH --nodes=1
#SBATCH -o samtoolsMergebam_2Apr_run.o%j

module load python/2.7.12 
module load samtools/current

" >>$res_script
for d in `ls $rep_bam_dir`; do
    bdir=`dirname $rep_bam_dir` 
    bam_dir="$bdir""/""Merged""/""$d"
        for b in `ls $bam_dir$ListFile_pat`;do
            ist_dir=`dirname "$b"`
            ist_bn=`basename "$b"` 
            bamlist_file="$ist_dir""/""$ist_bn"  
                for i in `ls $bam_dir$bam_pat`;do
                    badir=`dirname $i`
                    if [[ $(basename $i) == *"cortexAligned.filtered.bam"* ]];then
                        bn=`basename $i | sed s/M[0-9]cortexAligned.filtered.bam$//`
                        in_bama="$badir""/""$bn""M1cortexAligned.filtered.bam"
                        in_bamb="$badir""/""$bn""M4cortexAligned.filtered.bam"
                        in_bamc="$badir""/""$bn""M5cortexAligned.filtered.bam"
                        out_bam="$output_loc""/""$bn""_merged.bam"
                        echo "samtools merge -b $bamlis_file $bamlist_file $out_bam $in_bama $in_bamb $in_bamc">>$res_script
                    else
                         bn=`basename $i | sed s/M[0-9]brainAligned.filtered.bam$//`
                         in_bamd="$badir""/""$bn""M1brainAligned.filtered.bam"
                         in_bame="$badir""/""$bn""M2brainAligned.filtered.bam"
                         in_bamf="$badir""/""$bn""M3brainAligned.filtered.bam"
                         out_bam="$output_loc""/""$bn""_merged.bam"
                         echo "samtools merge -b $bamlist_file $out_bam $in_bamd $in_bame $in_bamf">>$res_script
                    fi
        done
    done
done        

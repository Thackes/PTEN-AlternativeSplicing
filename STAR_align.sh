##################################################################
# AIM : to make a slurm script to align trimmed fastq files
# Input: trimmed fastq files
# Ouput: sorted, bam files
# Author: Marilyn Seyfi
# email: seyfim@ccf.org
# Date: 20 Feb 2018
################################################################
#------------------------- modify here -------------------

# Index STAR indexed GRCm38 reference genome
export user_base="/home/seyfim/isilon/NGS_Working/Lamis_Yehia/Busch_TLE.PreOP.Memory.miRNAseq/data"
export STARIndex_ref=${user_base}"/STAR.Index"
# Dirs
export fqs_dir=${user_base}"/HQ-and-Adapters.Removed_fastq/Technical.Replicates.Concatenated"
export STAR_bam_loc=${user_base}"/BAM.files"
export gtf_file="/home/seyfim/isilon/NGS_Working/Library_Files/Genome/Human/hg38/gencode/gencode.v33.long_noncoding_RNAs.gtf"
export star="/cm/shared/apps/STAR/2.5.2b/STAR"

params="--sjdbGTFfile ${gtf_file} 
--alignEndsType EndToEnd
--outFilterMismatchNmax 1
--outFilterMultimapScoreRange 0
--quantMode TranscriptomeSAM GeneCounts
--outReadsUnmapped Fastx
--outFilterMultimapNmax 10
--outSAMunmapped Within
--outFilterScoreMinOverLread 0
--outFilterMatchNminOverLread 0
--outFilterMatchNmin 16
--alignSJDBoverhangMin 1000
--alignIntronMax 1
--outWigType wiggle
--outWigStrand Stranded"
# Pattern in fastq | fastq.gz
fqs_pat="/*_R1-HQ-Trimmed-No.Adapters.fastq"

#----------------------------------------------------------

module load python/2.7.12
module load STAR/2.5.2b

for i in $(ls ${fqs_dir}${fqs_pat}); do

  bdir=$(dirname "$i")
  bn=$(basename "$i" | sed s/_R1-HQ-Trimmed-No.Adapters.fastq//)
  export R1=$i
  # export R2=$bdir"/"$bn"_2R.fastq"
  export OUT=${STAR_bam_loc}/$bn
  
  ${star} --runThreadN 28 --genomeDir ${STARIndex_ref} --readFilesIn ${R1}  --outFileNamePrefix ${OUT}  --outSAMtype BAM SortedByCoordinate  --outFilterIntronMotifs RemoveNoncanonical $params

done

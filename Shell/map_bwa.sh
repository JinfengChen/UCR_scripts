#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l mem=30g
#PBS -l walltime=10:00:00

cd $PBS_O_WORKDIR

#ref=/rhome/cjinfeng/HEG4_cjinfeng/MappingReads/input/MSU_r7.fa
#read1=HEG4_2.3.mPing.20X_p1.sorted.fq
#read2=HEG4_2.3.mPing.20X_p2.sorted.fq
ref=nivara_IRGC105327_RelocaTEi_100bp_Ping.fasta
read1=nivara_IRGC105327_1.fq.gz
read2=nivara_IRGC105327_1.fq.gz
prefix=nivara_IRGC105327_mPing_ref

module load samtools/0.1.19
module load picard

echo "Mapping"
/rhome/cjinfeng/BigData/00.RD/RelocaTE2/tools/bwa-0.6.2/bwa aln -t $PBS_NP -l 20 $ref $read1 > $read1.sai
/rhome/cjinfeng/BigData/00.RD/RelocaTE2/tools/bwa-0.6.2/bwa aln -t $PBS_NP  -l 20 $ref $read2 > $read2.sai
/rhome/cjinfeng/BigData/00.RD/RelocaTE2/tools/bwa-0.6.2/bwa sampe $ref $read1.sai $read2.sai $read1 $read2 > $prefix.sam
echo "Convert Bam"
samtools view -bS -o $prefix.raw.bam $prefix.sam
samtools sort -@ $PBS_NP $prefix.raw.bam $prefix.sort
echo "RM dup"
picard MarkDuplicates ASSUME_SORTED=TRUE REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=SILENCE INPUT=$prefix.sort.bam OUTPUT=$prefix.bam METRICS_FILE=$prefix.dupli
echo "Clean"
#rm $prefix.sam $prefix.raw.bam $prefix.sort.bam $read1.sai $read2.sai
echo "Done"


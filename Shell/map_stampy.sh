#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=8g
#PBS -l walltime=100:00:00
#PBS -d ./

#cd $PBS_O_WORKDIR

start=`date +%s`

#ref=/rhome/cjinfeng/HEG4_cjinfeng/MappingReads/input/MSU_r7.fa
#ref=/rhome/cjinfeng/HEG4_cjinfeng/Variations/mPing/mPing_reads/input/mping.fa
#read1=HEG4_2.3.mPing.20X_p1.sorted.fq
#read2=HEG4_2.3.mPing.20X_p2.sorted.fq
#ref=Rice.TE.fa
ref=Rice.TE.short.unique.fa
read1=/rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Real_Data/Rice_50/RelocaTEi/51250_IND_RelocaTEi_allTE_bwa/repeat/fastq_split/p17.51250_IND_2.fq
#read1=/rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Real_Data/Rice_50/RelocaTEi/Rice_50_fastq/51250_IND/51250_IND_1.fq.gz
#read1=HEG4_2.3_p1.fq
#read2=HEG4_2.3_p2.fq
prefix=p17.51250_IND_2.te_repeat
#index=rice_MSU7
index=rice_TE

echo "Mapping"
/opt/stampy/1.0.21-py2.7/stampy.py --species=rice --assembly=MSU7 -G $index $ref
/opt/stampy/1.0.21-py2.7/stampy.py -g $index -H $index
/opt/stampy/1.0.21-py2.7/stampy.py -g $index -h $index -M $read1 | /opt/samtools-0.1.16/samtools view -Shb -F 4 - > $prefix.bam
#/opt/stampy/1.0.21-py2.7/stampy.py -g $index -h $index -M $read1 $read2 > $prefix.sam

echo "Convert Bam"
#/usr/local/bin/samtools view -bS -o $prefix.raw.bam $prefix.sam
#/usr/local/bin/samtools sort $prefix.raw.bam $prefix.sort
#mv $prefix.sort.bam $prefix.bam

end=`date +%s`

runtime=$((end-start))

echo "runtime: $runtime"


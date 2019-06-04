#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=8g
#PBS -l walltime=100:00:00
#PBS -d ./
#PBS -j oe

#cd $PBS_O_WORKDIR

start=`date +%s`

#ref=/rhome/cjinfeng/HEG4_cjinfeng/MappingReads/input/MSU_r7.fa
#ref=/rhome/cjinfeng/HEG4_cjinfeng/Variations/mPing/mPing_reads/input/mping.fa
#read1=HEG4_2.3.mPing.20X_p1.sorted.fq
#read2=HEG4_2.3.mPing.20X_p2.sorted.fq
#ref=Rice.TE.fa
ref=Rice.TE.short.unique.fa
#read1=/rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Real_Data/Rice_50/RelocaTEi/51250_IND_RelocaTEi_allTE_bwa/repeat/fastq_split/p17.51250_IND_2.fq
read1=/rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Real_Data/Rice_50/RelocaTEi/51250_IND_RelocaTEi_allTE_bwa/repeat/fastq_split/p155.51250_IND_2.fq
#read1=/rhome/cjinfeng/BigData/00.RD/RelocaTE_i/Real_Data/Rice_50/RelocaTEi/Rice_50_fastq/51250_IND/51250_IND_1.fq.gz
#read1=HEG4_2.3_p1.fq
#read2=HEG4_2.3_p2.fq
prefix=p17.51250_IND_2.te_repeat
#index=rice_MSU7
index=rice_TE

echo "Mapping"
#/opt/stampy/1.0.21-py2.7/stampy.py --species=rice --assembly=MSU7 -G $index $ref
#/opt/stampy/1.0.21-py2.7/stampy.py -g $index -H $index
#/opt/stampy/1.0.21-py2.7/stampy.py -g $index -h $index -M $read1 | /opt/samtools-0.1.16/samtools view -Shb -F 4 - > $prefix.bam
#/opt/stampy/1.0.21-py2.7/stampy.py -g $index -h $index -M $read1 $read2 > $prefix.sam
#/opt/bowtie2/2.2.3/bowtie2-build Rice.TE.short.unique.fa Rice.TE.short.unique
/opt/bowtie2/2.2.3/bowtie2 --mp 3 --score-min G,10,3 -L 15 --rdg 1,1 --rfg 1,1 -D 20 -R 3 -N 0 -i S,1,0.50 --local -a -x Rice.TE.short.unique -U $read1 | /opt/samtools-0.1.16/samtools view -Shb -F 4 - > p155.51250_IND_2.te_repeat.bowtie.bam

echo "Convert Bam"
#/usr/local/bin/samtools view -bS -o p17.51250_IND_2.te_repeat.bowtie.raw.bam p17.51250_IND_2.te_repeat.bowtie.sam
#/usr/local/bin/samtools sort $prefix.raw.bam $prefix.sort
#mv $prefix.sort.bam $prefix.bam

end=`date +%s`

runtime=$((end-start))

echo "runtime: $runtime"


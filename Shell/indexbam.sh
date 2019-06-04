#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=10:00:00

cd $PBS_O_WORKDIR

module load samtools
for i in `ls *.bam | sed 's/@//'`
do
   echo $i
   if [ ! -e $i.bai ]; then
       samtools index $i
   fi
done


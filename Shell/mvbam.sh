#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=10:00:00
#PBS -d ./

#cd $PBS_O_WORKDIR


for i in `ls *.bam | sed 's/@//'`
do
   echo $i
   prefix=${i%.bam}
   newpre=${prefix/RIL/GN}
   echo $prefix
   echo $newpre
   mv $prefix\.bam $newpre\.bam
   mv $prefix\.bam.bai $newpre\.bam.bai
   mv $prefix\.dedup.flagstats $newpre\.dedup.flagstats
   #if [ ! -e $i.bai ]; then
   #/usr/local/bin/samtools index $i
   #fi
done


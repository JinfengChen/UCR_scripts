#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=10:00:00
#PBS -d ./
#PBS -j oe

#cd $PBS_O_WORKDIR
#qsub -t 1-7 indexbam_qsub.sh
start=`date +%s`

module load samtools

CPU=$PBS_NP
if [ ! $CPU ]; then
   CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
    N=$1
fi

FILE=`ls -1 *.bam | head -n $N | tail -n 1`

ril=${FILE%_*_*_*.recal.bam}
prefix=${FILE%.*}
echo $ril
echo $prefix
if [ ! -e $ril\.bam ]; then
   mv $prefix\.bam $ril\.bam
   mv $ril\.bam\.dedup\.flagstats $ril\.dedup\.flagstats
   #mv $prefix\.bam\.bai $ril\.bam\.bai
   #mv $prefix\.dedup\.flagstats $ril\.dedup\.flagstats
   #samtools flagstat $FILE > $prefix\.dedup.flagstats
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


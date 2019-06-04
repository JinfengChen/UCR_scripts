#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l mem=5gb
#PBS -l walltime=10:00:00
#PBS -d ./
#PBS -j oe

#cd $PBS_O_WORKDIR
#qsub -t 1-36 fastq2fasta.sh

module load samtools

CPU=$PBS_NP
if [ ! $CPU ]; then
   CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
    N=$1
fi

FILE=`ls -1 *.fq | head -n $N | tail -n 1`

#gzip $FILE
pigz $FILE -p 16

echo "Done"

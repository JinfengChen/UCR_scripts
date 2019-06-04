#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
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

FILE=`ls -1 *.fastq | head -n $N | tail -n 1`

prefix=${FILE%.*}
if [ ! -e $prefix\.fasta ]; then
   ~/BigData/software/seqtk-master/seqtk seq -A $FILE > $prefix\.fasta
fi


echo "Done"

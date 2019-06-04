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

FILE=`ls -1 *.bax.h5 | head -n $N | tail -n 1`

prefix=${FILE%.bax.h5}
echo $prefix
if [ ! -e $prefix\.subreads.fasta ]; then
   ~/BigData/00.RD/Assembly/Pacbio/install/blasr_20160808/blasr/utils/pls2fasta -trimByRegion $FILE $prefix\.subreads.fasta
fi


echo "Done"

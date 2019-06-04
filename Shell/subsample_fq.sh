#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=20G
#SBATCH --time=10:00:00
#SBATCH --output=stdout
#SBATCH -p intel
#SBATCH --workdir=./

module load seqtk

CPU=$PBS_NP
if [ ! $CPU ]; then
   CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
    N=1
fi

FILE=`ls -1 *.fastq.gz | head -n $N | tail -n 1`
#for FILE in `ls *.fastq.gz | sed 's/@//'`
echo $FILE
prefix=${FILE%.fastq.gz}
raw=$prefix.raw.fastq.gz
mv $FILE $raw
if [ ! -e $prefix.fastq.gz ]; then
   seqtk sample $raw 0.1 > $prefix.fastq
   pigz $prefix.fastq -p 16
   chmod 664 $prefix.fastq.gz
fi

echo "Done"

#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=100G
#SBATCH --time=12:00:00
#SBATCH --output=stdout
#SBATCH -p batch
#SBATCH --workdir=./

module load samtools
CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=$1
fi

FILE=`ls -1 *.bam | head -n $N | tail -n 1`

prefix=${FILE%.*}
if [ ! -e $prefix\.dedup.flagstats ]; then
   samtools flagstat $FILE > $prefix\.dedup.flagstats
   /rhome/cjinfeng/BigData/software/qualimap/qualimap_v2.1.2/qualimap bamqc -bam $FILE --java-mem-size=36G -nt 24 -outformat PDF
fi


echo "Done"

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=10G
#SBATCH --time=1:00:00
#SBATCH --output=gz_zip_slurm.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi


FILE=`ls -1 *.fastq | head -n $N | tail -n 1`

#tar -zxvf $FILE
#gunzip -d $FILE
#bzip2 -d $FILE
pigz $FILE -p 16

echo "Done"

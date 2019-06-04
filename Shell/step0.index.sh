#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=4:00:00
#SBATCH --output=stdout
#SBATCH -p batch
#SBATCH --workdir=./


ref=MSU_r7.fa
dict=MSU_r7.dict

module load samtools
module load picard

picard CreateSequenceDictionary R=$ref O=$dict
samtools faidx $ref

echo "Done"


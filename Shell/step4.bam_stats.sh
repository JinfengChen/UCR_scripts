#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH -p intel
#SBATCH --workdir=./

module load samtools
bam=Nc_OR.bam
prefix=${bam%.*}
echo $bam
echo $prefix
samtools flagstat $bam > $prefix\.flagstat
/rhome/cjinfeng/BigData/software/qualimap/qualimap_v2.1.2/qualimap bamqc -bam $bam --java-mem-size=20G -nt 1 -outformat PDF


echo "Done"


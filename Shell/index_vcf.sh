#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem=10G
#SBATCH --time=1:00:00
#SBATCH --output=index_vcf.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./

start=`date +%s`

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi

echo "CPU: $CPU"
echo "N: $N"

vcf=dbSNP.clean.Het.vcf

module load htslib
bgzip < $vcf > $vcf\.gz
tabix -p vcf $vcf\.gz

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

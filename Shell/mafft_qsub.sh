#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH --output=run_speedseq_qsub.sh.stdout
#SBATCH -p intel
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh

module load mafft
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

FILE=`ls *.fa | head -n $N | tail -n 1`
SAMPLE=${FILE%.fa}
echo "File: $FILE"

if [ ! -e $SAMPLE\.msa ]; then
echo "Aligning $FILE ....."

mafft --ep 0.15 --op 1.55 --thread $CPU --localpair --maxiterate 16 $FILE > $SAMPLE\.msa

fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

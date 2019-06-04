#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH --output=run_speedseq_qsub.sh.stdout
#SBATCH -p intel
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh

module load samtools
PATH=$PATH:~/BigData/software/SVcaller/ROOT/bin/
genome=Fairchild_canu1_3.quiver_round1_pilon.fasta

start=`date +%s`

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=$1
fi

echo "CPU: $CPU"
echo "N: $N"

FILE=`ls *_1.fq.gz | grep _1\.fq\.gz | head -n $N | tail -n 1`
R1=$FILE
R2=`echo $R1 | perl -p -e 's/_1\.fq/_2.fq/'`
SAMPLE=${FILE%_1.fq.gz}
echo "File: $FILE"
echo "Read: $R1 and $R2"
echo "Sample: $SAMPLE"

mkdir $SAMPLE
mv $R1 $SAMPLE
mv $R2 $SAMPLE

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

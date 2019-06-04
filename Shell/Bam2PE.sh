#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH --output=Bam2PE.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh

module load samtools/1.8
module load bedtools/2.25.0

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

FILE=`ls *.bam | head -n $N | tail -n 1`
SAMPLE=${FILE%.bam}
echo "File: $FILE"
echo "Sample: $SAMPLE"

if [ ! -e $SAMPLE\_1.fastq.gz ]; then
   samtools sort -m 1000000000 -n $FILE -o $SAMPLE\.nsort.bam -@ $CPU
   bedtools bamtofastq -i $SAMPLE\.nsort.bam -fq $SAMPLE\_1.fastq -fq2 $SAMPLE\_2.fastq
   pigz $SAMPLE\_1.fastq -p $CPU
   chmod 664 $SAMPLE\_1.fastq.gz
   pigz $SAMPLE\_2.fastq -p $CPU
   chmod 664 $SAMPLE\_2.fastq.gz
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

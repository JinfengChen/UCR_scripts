#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH --output=run_speedseq_qsub.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./

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

genome=~/BigData/00.RD/Assembly/Pacbio/Reference/Fairchild/Fairchild_v1.fasta
read1=Venki-2_S2_R1_001.fastq.gz
prefix=Venki_2_S2_R1_001

module load samtools/0.1.19
module load picard

echo "Mapping"
/opt/linux/centos/7.x/x86_64/pkgs/bwa/0.7.12/bin/bwa mem -t $CPU $genome $read1 > $prefix\.sam
echo "Convert Bam"
/opt/linux/centos/7.x/x86_64/pkgs/samtools/0.1.19/bin/samtools view -bS -o $prefix\.raw.bam $prefix\.sam
/opt/linux/centos/7.x/x86_64/pkgs/samtools/0.1.19/bin/samtools sort -@ $CPU $prefix\.raw.bam $prefix\.sort
echo "RM dup"
picard MarkDuplicates ASSUME_SORTED=TRUE REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=SILENT INPUT=$prefix.sort.bam OUTPUT=$prefix.bam METRICS_FILE=$prefix.dupli
echo "Clean"
#rm $prefix.sam $prefix.raw.bam $prefix.sort.bam $read1.sai $read2.sai
echo "Done"


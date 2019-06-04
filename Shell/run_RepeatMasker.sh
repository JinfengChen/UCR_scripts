#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem-per-cpu=2G
#SBATCH --time=20:00:00
#SBATCH --output=stdout
#SBATCH --job-name="RepeatMasker"
#SBATCH -p intel
#SBATCH --array=1

module load RepeatMasker/4-0-7
repeat_to_gff=~/BigData/software/bin/repeat_to_gff.pl
statTE=~/BigData/software/bin/stat_TE.pl

LIB_FILE=FC_TEdenovo.classif.fa
GENOME_FILE=Fairchild_v1.fasta

#RepeatMasker -engine ncbi -parallel $SLURM_NTASKS -lib $LIB_FILE $GENOME_FILE -q -xsmall -nolow -no_is -norna
mv $GENOME_FILE\.out $GENOME_FILE\.RepeatMasker.out
perl $repeat_to_gff $GENOME_FILE\.RepeatMasker.out
perl $statTE --repeat $GENOME_FILE\.RepeatMasker.out --rank 'all' > $GENOME_FILE\.RepeatMasker.out.stat.all
perl $statTE --repeat $GENOME_FILE\.RepeatMasker.out --rank 'type' > $GENOME_FILE\.RepeatMasker.out.stat.type
perl $statTE --repeat $GENOME_FILE\.RepeatMasker.out --rank 'subtype' > $GENOME_FILE\.RepeatMasker.out.stat.subtype
perl $statTE --repeat $GENOME_FILE\.RepeatMasker.out --rank 'family' > $GENOME_FILE\.RepeatMasker.out.stat.family

echo "Done"

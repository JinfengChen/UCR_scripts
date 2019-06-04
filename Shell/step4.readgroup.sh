#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --time=40:00:00
#SBATCH --output=run_speedseq_qsub.sh.stdout
#SBATCH -p intel
#SBATCH --workdir=./

module load picard

bam=citrus_raw_plus_20kb_pread_bwa_mem.bam
prefix=${bam%.*}
group=Fairchild
picard AddOrReplaceReadGroups VALIDATION_STRINGENCY=LENIENT I=$bam O=$prefix.readgroup.bam ID=$group LB=pacbio PL=pacbio PU=pacbio SM=OR

echo "Done"


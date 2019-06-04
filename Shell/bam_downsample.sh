#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=20g
#PBS -l walltime=100:00:00
#PBS -d ./
#PBS -j oe

#cd $PBS_O_WORKDIR

module load bamtools
module load samtools

prefix=WLM
p=0.3
bam=$prefix\.bam
bam_out=$prefix\.30X.bam
Picard=/opt/picard/1.81/

java -Xmx16m -jar $Picard/DownsampleSam.jar I=$bam O=$bam_out P=$p
#samtools sort A119.HEG4allpathv1_BWA.ALL.random.bam A119.HEG4allpathv1_BWA.ALL.random.sort


echo "Done"

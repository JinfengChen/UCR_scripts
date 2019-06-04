#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=10:00:00
#PBS -d ./
#PBS -j oe

#cd $PBS_O_WORKDIR
#qsub -t 1-7 indexbam_qsub.sh
start=`date +%s`

module load hisat2/2.0.5
hisat2-build -p $PBS_NP Cclementina_v1.0_scaffolds.fa Cclementina_v1.0_scaffolds_tran

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


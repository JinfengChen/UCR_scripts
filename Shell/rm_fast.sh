#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=10:00:00
#PBS -d ./

#cd $PBS_O_WORKDIR


for i in {150..360};
do
   echo $i
   rm p$i.*.fq p$i.*.fa
done


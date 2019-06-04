#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=10:00:00

#cd $PBS_O_WORKDIR


for i in `ls Nivara* | sed 's/@//'`
do
   echo $i
   new=`ls $i | perl -p -e 's/Ping/MSU7/'`
   echo $new
   mv $i $new
done


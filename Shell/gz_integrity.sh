#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l mem=20gb
#PBS -l walltime=10:00:00
#PBS -d ./


for i in `ls *.gz | sed 's/@//'`
do
   echo $i
   pigz -t $i -p 16
   #gunzip -t $i
done

echo "Done"

#!/bin/sh


for i in {135..170}
do
   if [ $i -ne 150 ]
   then
       job=work_00$i\.sh
       echo $job
       qsub -l nodes=1:ppn=1,walltime=100:00:00,mem=10G $job
   fi
done


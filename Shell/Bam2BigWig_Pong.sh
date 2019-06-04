#!/bin/bash
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=100:00:00
#PBS -j oe
#PBS -V
#PBS -d ./

#cd $PBS_O_WORKDIR


start=`date +%s`
module load kent

genome=/rhome/cjinfeng/BigData/03.SmallRNA/reference/Ping_Pong.fa
chrlen=/rhome/cjinfeng/BigData/03.SmallRNA/reference/Ping_Pong.chrlen
chrlen2=/rhome/cjinfeng/BigData/00.RD/seqlib/MSU7.chrlen
#bam=NB_embryo.trim3_5.rfam.repeat.bam
#bam=NB_embryo.trim3_5.rfam.genome.bam
#prefix=${bam%*.bam}
#python ~/BigData/software/RSeQC/usr/bin/bam2wig.py -s $chrlen -i $bam -o $prefix -u -q 10
#python bam2wig.py -s $chrlen -i $bam -o $prefix -u


for bam in `ls *.repeat.bam | sed 's/@//'`
do
   prefix=${bam%*.repeat.bam}
   bam2=$prefix\.genome.bam
   echo $bam, $prefix, $bam2
   if [ ! -e $prefix\.repeat\.bw ]; then
       #python ~/BigData/software/RSeQC/usr/bin/bam2wig.py -s $chrlen -y $chrlen2 -i $bam -x $bam2 -o $prefix\.repeat -u -q 10 -t 100000000
       wigToBigWig $prefix\.repeat\.wig $chrlen $prefix\.repeat\.bw
   fi
done




end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


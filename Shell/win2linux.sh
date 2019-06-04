#!/bin/sh


for i in `ls *_manual.csv | sed 's/@//'`
do
   FILENAME=$i
   prefix=${FILENAME%%.*}
   newfile=$prefix.matrix.csv
   echo $i
   echo $newfile
   tr "\r" "\n" < $i > $newfile
done


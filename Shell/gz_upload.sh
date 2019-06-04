#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=10:00:00
#SBATCH --output=stdout
#SBATCH -p intel
#SBATCH --workdir=./

module load icommands/iPlant
newdir=`basename "$PWD"`
icd /iplant/home/jinfeng7chen/Shared_data/
#imkdir $newdir
#icd $newdir
for i in `ls *.gz | sed 's/@//'`
do
   echo $i
   iput $i
done

echo "Done"

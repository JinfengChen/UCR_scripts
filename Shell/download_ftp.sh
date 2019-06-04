#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=20G
#SBATCH --time=1:00:00
#SBATCH --output=download_ftp.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi


FILE=`cat ftp.list3 | head -n $N | tail -n 1`
ftpuser=P202SC18081709-01_20181030_B4EXS2
password=CcRxhZ
wget --user=$ftpuser --password=$password $FILE

echo "Done"

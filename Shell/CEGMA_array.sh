#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=30G
#SBATCH --time=20:00:00
#SBATCH --output=CEGMA_array.sh.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./



start=`date +%s`

module load ncbi-blast/2.2.26+
module load hmmer/3.0
module load geneid/1.4.4
module load cegma/2.5
export CEGMA="/opt/linux/centos/7.x/x86_64/pkgs/cegma/2.5/"
export CEGMATMP="/scratch/"
export PERL5LIB="$PERL5LIB:$CEGMA/lib"

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi


FILE=`ls *.f*a | head -n $N | tail -n 1`
genome=$FILE
prefix=${genome%%.f*a}
output=run_$prefix\.CEGMA
echo $genome
echo $output
export CEGMATMP="`pwd`/output_$output"
if [ ! -e "output_$output" ]; then
    echo "Not run: $genome"
    mkdir "output_$output"
    ln -s `pwd`/$genome output_$output/$genome
    cd output_$output
    cegma -g $genome --threads $SLURM_NTASKS --output $output
    perl /opt/linux/centos/7.x/x86_64/pkgs/cegma/2.5/bin/completeness local_self.hmm_select.aln /opt/linux/centos/7.x/x86_64/pkgs/cegma/2.5//data/completeness_cutoff.tbl > $output\.completeness_report
    cd ..
fi

if [ -e "output_$output" ]; then
   report=output_$output/$output\.completeness_report
   filesize=`wc -c $report | awk '{print $1}'`
   echo $filesize
   if [ $filesize -lt 100 ]; then
       echo "Run failed: $genome"
       mkdir "output_$output"
       ln -s `pwd`/$genome output_$output/$genome
       cd output_$output
       cegma -g $genome --threads $SLURM_NTASKS --output $output
       perl /opt/linux/centos/7.x/x86_64/pkgs/cegma/2.5/bin/completeness local_self.hmm_select.aln /opt/linux/centos/7.x/x86_64/pkgs/cegma/2.5//data/completeness_cutoff.tbl > $output\.completeness_report
       cd ..
   fi
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


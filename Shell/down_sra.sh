#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=4:00:00
#SBATCH --output=run_speedseq_qsub.sh.stdout
#SBATCH -p intel
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh

module load samtools
PATH=$PATH:~/BigData/software/SVcaller/ROOT/bin/
genome=Fairchild_canu1_3.quiver_round1_pilon.fasta

start=`date +%s`

/opt/linux/centos/7.x/x86_64/pkgs/aspera/3.3.3/bin/ascp -i /opt/linux/centos/7.x/x86_64/pkgs/aspera/3.3.3/etc/asperaweb_id_dsa.openssh -k 1 -T -l20m anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR331/SRR3316952/SRR3316952.sra /bigdata/stajichlab/cjinfeng/software/TE_diversity/EpiTEome/ddm1/Citrus_RNAseq/SRR3316952

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

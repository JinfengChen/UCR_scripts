#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=50G
#SBATCH --time=40:00:00
#SBATCH --output=buscov3_gene_array.%A_%a.stdout
#SBATCH -p intel
#SBATCH --workdir=./


start=`date +%s`

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi

module load augustus
#genome=Fairchild_contig_graph.raw.named_pilon.fasta
#output=Fairchild_contig_graph.raw.named_pilon.BUSCO
lineage=/rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/install/BUSCO/busco/dataset/embryophyta_odb9
export AUGUSTUS_CONFIG_PATH=/rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/install/BUSCO/busco/augustus_config

temp=/rhome/cjinfeng/Rice/Rice_population_sequence/BUSCO/PlantGenome/tmp
#genome=test.fa
#lineage=/rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/Evaluation/completeness/BUSCO/eukaryota
#lineage=/rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/Evaluation/completeness/BUSCO/plant_early_release/plantae
#busco=/rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/Evaluation/completeness/BUSCO/plant_early_release/BUSCO_plants.py
#/opt/linux/centos/7.x/x86_64/pkgs/python/3.4.3/bin/python3 
#python $busco --genome $genome -c $CPU --lineage $lineage -a $output
#busco.py --genome $genome -c $PBS_NP --lineage $lineage -o $output
FILE=`cat genome.list | head -n $N | tail -n 1`
genome=$FILE
SAMPLE=${FILE%.f*a}
output=$SAMPLE\.BUSCO
echo "genome: $FILE"
echo "output: $output"

if [ ! -e "run_$output" ]; then
   python ~/BigData/00.RD/Assembly/Pacbio/install/BUSCO/busco/scripts/run_BUSCO.py --in $genome --cpu $CPU --out $output --lineage_path $lineage --mode prot --tmp_path $temp
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


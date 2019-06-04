#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import re
import os
import argparse
import glob
import fnmatch
from Bio import SeqIO
sys.path.append('/rhome/cjinfeng/BigData/software/ProgramPython/lib')
from utility import gff_parser, createdir

def usage():
    test="name"
    message='''
python summary_busco.py --input ./

    '''
    print message


def runjob(script, lines):
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-pbs.pl --maxjob 30 --lines %s --interval 120 --resource nodes=1:ppn=12,walltime=100:00:00,mem=20G --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)



def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid


'''
Summarized BUSCO benchmarking for file: /rhome/cjinfeng/BigData/00.RD/Assembly/Pacbio/Evaluation/completeness/BUSCO/TAIR_versions/arabidopsis/Arabidopsis_Bur0_NGS.fa
#BUSCO was run in mode: genome

Summarized benchmarks in BUSCO notation:
	C:0%[D:0%],F:0%,M:0%,n:956

Representing:
	875	Complete Single-Copy BUSCOs
	147	Complete Duplicated BUSCOs
	12	Fragmented BUSCOs
	69	Missing BUSCOs
	956	Total BUSCO groups searched
'''
def summary_busco(infile):
    data = defaultdict(lambda : str())
    flag = 0 
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and flag == 0 and line.startswith(r'Representing'):
                flag = 1
            elif flag == 1: 
                line = line.lstrip()
                unit = re.split(r'\t',line)
                data[unit[1]] = unit[0]
    return data


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    types = ['Complete Single-Copy BUSCOs', 'Complete Duplicated BUSCOs', 'Fragmented BUSCOs', 'Missing BUSCOs', 'Total BUSCO groups searched']
    print 'Genome\t%s' %('\t'.join(types))
    busco_dirs = glob.glob('%s/run_*.BUSCO' %(args.input))
    for busco in sorted(busco_dirs):
        for f in os.listdir(busco):
            if fnmatch.fnmatch(f, 'short_summary_*.BUSCO'):
                busco_sum = summary_busco('%s/%s' %(busco, f))
                name= re.sub(r'run_|.BUSCO', r'', os.path.split(busco)[1])
                out = []
                for t in types:
                    out.append(busco_sum[t])
    
                print '%s\t%0.3f\t%0.3f\t%0.3f\t%s' %(name, float(out[0])/int(out[4]), float(out[2])/int(out[4]), float(out[3])/int(out[4]), '\t'.join(out))
    
        
if __name__ == '__main__':
    main()


#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import re
import os
import argparse
import glob
from Bio import SeqIO
sys.path.append('/rhome/cjinfeng/BigData/software/ProgramPython/lib')
from utility import gff_parser, createdir

def usage():
    test="name"
    message='''
python Bam_Cov_SlidingWin.py --input Cclementina_v1.0_scaffolds.9.slidingwin.bed.hist.cov

This script generate read coverage from bam using sliding window method. Generate bed format of window using makewindows, then use coverage to calculate hist on these bed. Use script to summary the result.
bedtools makewindows -g ../Reference/Cclementina_JGI_v1.0/Cclementina_v1.0_scaffolds.9.chrlen -w 100000 -s 50000 > Cclementina_v1.0_scaffolds.9.slidingwin.bed
bedtools coverage -abam Citrus_asm40_quiver_round2.bam -b Cclementina_v1.0_scaffolds.9.slidingwin.bed -hist > Cclementina_v1.0_scaffolds.9.slidingwin.bed.hist.cov &

    '''
    print message


def runjob(script, lines):
    cmd = 'perl /rhome/cjinfeng/software/bin/qsub-pbs.pl --maxjob 30 --lines %s --interval 120 --resource nodes=1:ppn=12,walltime=100:00:00,mem=20G --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)



def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid

'''
scaffold_1	400000	500000	2	609	100000	0.0060900
scaffold_1	400000	500000	3	322	100000	0.0032200
all	0	33787	1000000	0.0337870
all	1	933818	1000000	0.9338180
all	2	18247	1000000	0.0182470
'''
def readtable(infile):
    data = defaultdict(lambda : defaultdict(lambda : int()))
    window = 100000
    step   = 50000
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and line.startswith(r'scaffold'): 
                unit = re.split(r'\t',line)
                scaf = re.sub(r'scaffold_', r'', unit[0])
                data[scaf][unit[1]] += int(unit[3])*int(unit[4])
    ofile = open('%s.bed' %(infile), 'w')
    for scaf in sorted(data.keys(), key=int):
        for start in sorted(data[scaf].keys(), key=int):
            end = int(start) + window
            depth = data[scaf][str(start)]/float(window)
            print >> ofile, 'scaffold_%s\t%s\t%s\t%.2f\t%s' %(scaf, start, end, depth,data[scaf][str(start)])
    ofile.close()


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

    readtable(args.input)

if __name__ == '__main__':
    main()


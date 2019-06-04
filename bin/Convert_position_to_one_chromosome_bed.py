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
python Convert_position_to_one_chromosome_bed.py --chr ../Citrus_diversity/bin/Cclementina_v1.0_scaffolds.chrlen --bed test.bed.hist.cov.bed

Convert bed position from 12 chromosome to 1 chromosome.
    '''
    print message

def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid

'''
1       0       100000  0.67    67033
1       50000   150000  1.00    100379
1       100000  200000  1.00    100000
1       150000  250000  1.08    107534
1       200000  300000  1.25    125074
1       250000  350000  1.20    120427
1       300000  400000  1.03    102887
'''
def convert_gff(infile, pos):
    data = defaultdict(lambda : int())
    #ofile = open(re.sub(r'.density', r'.1chr.density', infile), 'w')
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and line.startswith(r'scaffold'):
                unit = re.split(r'\t', line)
                unit[1] = str(pos[unit[0]] + int(unit[1]))
                unit[2] = str(pos[unit[0]] + int(unit[2]))
                unit[0] = 'scaffold_1'
                print '\t'.join(unit)
            else:
                print line
    #ofile.close()

'''
scaffold_1	28940638
scaffold_2	36376123
scaffold_3	51050279
scaffold_4	25649528
scaffold_5	43300495
scaffold_6	25613772
'''
def read_chr(infile):
    data = defaultdict(lambda : int())
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and line.startswith(r'scaffold'): 
                unit = re.split(r'\t',line)
                chrs = int(re.sub(r'scaffold_', r'',unit[0]))
                data[chrs] = int(unit[1])
    last = 0
    pos  = defaultdict(lambda : int())
    for c in sorted(data.keys(), key=int):
        pos['scaffold_%s' %(c)] = last
        last  += data[c]
        #print 'Chr%s\t%s' %(c, pos[c])
    return pos


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--chr')
    parser.add_argument('-b', '--bed')
    args = parser.parse_args()
    try:
        len(args.chr) > 0
    except:
        usage()
        sys.exit(2)

    pos = read_chr(args.chr)
    convert_gff(args.bed, pos)

if __name__ == '__main__':
    main()


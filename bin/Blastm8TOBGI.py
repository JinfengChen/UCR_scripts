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
python Blastm8TOBGI.py --input Castaway.fasta36.m8 --query_fa Castaway.fa --target_fa Castaway.fa

    '''
    print message


def runjob(script, lines):
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl --maxjob 60 --lines 2 --interval 120 --task 1 --mem 15G --time 100:00:00 --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)



def read_fasta(fastafile):
    fastaid = defaultdict(lambda : str())
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = str(record.seq)
    return fastaid

#input m8:
#rice_3_118674	rice_3_118674	100.00	364	0	0	1	364	1	364	2.4e-89	317.3
#rice_3_118674	pep-hit28_Chr10_17297421_17297840_plus	69.74	152	44	2	1	151	8941	9091	6.8e-15	69.9

#output table:
#Query_id	Query_length	Query_start	Query_end	Subject_id	Subject_length	Subject_start	Subject_end	Identity	Positive	Gap	Align_length	Score	E_value	Query_annotation	Subject_annotation
#rice_3_118674	364	1	364	rice_3_118674	364	1	364	1	--	0	364	722	0.0	TSD Len:3 31 	TSD Len:3 31
def convert_table(infile, qry, tag):
    print 'Query_id\tQuery_length\tQuery_start\tQuery_end\tSubject_id\tSubject_length\tSubject_start\tSubject_end\tIdentity\tPositive\tGap\tAlign_length\tScore\tE_value'
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2: 
                unit = re.split(r'\t',line)
                query_id     = unit[0]
                query_length = len(qry[query_id])
                query_start  = unit[6]
                query_end    = unit[7]
                subject_id   = unit[1]
                subject_length = len(tag[subject_id])
                subject_start  = unit[8]
                subject_end    = unit[9]
                identity       = unit[2]
                positive       = '--'
                gap            = unit[5]
                align_length   = unit[3]
                score          = unit[11]
                e_value        = unit[10]
                print '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' %(query_id, query_length, query_start, query_end, subject_id, subject_length, subject_start, subject_end, identity, positive, gap, align_length, score, e_value)
           

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('--query_fa')
    parser.add_argument('--target_fa')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    qry_fa = read_fasta(args.query_fa)
    tag_fa = read_fasta(args.target_fa)
    convert_table(args.input, qry_fa, tag_fa)

if __name__ == '__main__':
    main()


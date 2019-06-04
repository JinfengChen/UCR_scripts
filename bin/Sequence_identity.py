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
python Sequence_identity.py --input Zt12g_CDS.aln --format clustal > Zt12g_CDS.aln.identity

Given an alingment file with multiple sequence alignment. The script calculate pairwise sequence identity between sequences.
Two identity values will be present in output: identity1 counts indels or gaps as alignment length and identity2 does not count indels or gaps as alignment length.
Identity1 is similar to the results of NCBI blast identity.

    '''
    print message


def runjob(script, lines, cpu, queue):
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl --maxjob 60 --lines %s --interval 120 --task %s --mem 15G --time 10:00:00 --queue %s --convert no %s' %(lines, cpu, queue, script)
    #print cmd 
    os.system(cmd)



def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid


def calculate_identity(seq1, seq2):
    identity1 = 0.0
    identity2 = 0.0
    gap1     = 0  #gaps shared by two sequences
    gap2     = 0  #gaps in one sequence
    na       = 0  #Ns in one or both sequences
    match    = 0  #matches
    mm       = 0  #mismatches
    for n in range(0, len(seq1)):
        if seq1[n].lower() == seq2[n].lower():
            if seq1[n] == "-":
                gap1   += 1
            elif seq1[n].lower() == 'n':
                na    += 1 
            else:
                match += 1
        else:
            if seq1[n] == "-" or seq2[n] == "-":
                gap2  += 1
            elif seq1[n].lower() == 'n' or seq2[n].lower() == 'n':
                na    += 1
            else:
                mm    += 1
    #if float(len(seq1)-gap1-na) > 0:
    #    identity1 = 100*(match/float(len(seq1)-gap1-na))
    #if float(len(seq1)-gap1-na) > 0:
   
    identity1 = 100*(match/float(len(seq1)-gap1-na)) if float(len(seq1)-gap1-na) > 0 else 'NA'       #count indels or gaps as alignment length
    identity2 = 100*(match/float(len(seq1)-gap1-gap2-na)) if float(len(seq1)-gap1-gap2-na) > 0 else 'NA'  #does not count indels or gaps as alignment length
    return [identity1, identity2]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-f', '--format')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    from Bio import AlignIO
    alignment = AlignIO.parse(args.input, args.format)
    align_count = 0
    print 'AlignmentID\tSeqID1\tSeqID2\tIdentity1(included Gaps)\tIdentity(excluded Gaps)'
    for record in alignment:
        #print 'record: %s' %(record)
        align_count += 1
        align_id     = '%s:%s' %(record[0].id, align_count)
        for i in range(0, len(record)):
            for j in range(i, len(record)):
                if not i == j:
                    seq_i = record[i].seq
                    seq_j = record[j].seq
                    #print '%s\t%s' %(i, j)
                    identity = calculate_identity(seq_i, seq_j)
                    print '%s\t%s\t%s\t%s\t%s' %(align_id, record[i].id, record[j].id, identity[0], identity[1])

if __name__ == '__main__':
    main()


#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
from numpy import *
import re
import os
import argparse
from Bio import SeqIO
from scipy import stats

def usage():
    test="name"
    message='''
python GFF_slidingWin.py --gff HEG4.ALL.mping.non-ref.gff --type mPing
 
    '''
    print message

def fasta(fastafile, win):
    fastaseq = defaultdict(str)
    step = int(0.25*win)
    n_win  = 0
    g_len  = 0
    for record in SeqIO.parse(fastafile,"fasta"):
        #print record.id
        seq = str(record.seq.upper())
        fastaseq[record.id] = seq
        n = int((len(seq)-win)/step) + 1
        n_win += n
        g_len += len(seq)
    return fastaseq, g_len

def complement(s): 
    basecomplement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A'} 
    letters = list(s) 
    letters = [basecomplement[base] for base in letters] 
    return ''.join(letters)

def revcom(s):
    return complement(s[::-1])


'''
read frquency matirx
>A	C	G	T
0.110	0.335	0.139	0.416
0.247	0.213	0.138	0.402
0.406	0.370	0.144	0.081
0.000	0.000	0.001	0.999
0.478	0.012	0.010	0.500
0.999	0.001	0.000	0.000
0.092	0.149	0.357	0.403
0.397	0.147	0.205	0.252
0.386	0.150	0.346	0.118
'''
def readmatrix(infile):
    data = defaultdict(lambda : defaultdict(lambda: float))
    count = 0
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and line.startswith(r'0'): 
                unit = re.split(r'\t',line)
                data['A'][count] = float(unit[0])
                data['C'][count] = float(unit[1])
                data['G'][count] = float(unit[2])
                data['T'][count] = float(unit[3])
                count += 1
    return data

def validdna(dna):
    flag = 1
    bases = ['A', 'T', 'C', 'G'] 
    for b in dna:
        if b not in bases:
            flag = 0
    return flag

'''
Given a sequence, return the probability one mPing insertion in the whole sequence including reverse strand.
P = (p1 + p2 + ... + pn)/Np, which pn is the probabilty of mPing insertion in the nth potential TSD and Np is the number of potential sites.
P is the probability of mping insertion in one of any these sites.
'''
def tsd_prob(seq, matrix):
    length = len(seq)
    win = 9
    runs = length-win-1
    probp = 0.00
    probn = 0.00
    Np = 0
    for i in range(runs):
        s    = i
        e    = s + win
        sitep = seq[s:e]
        if not validdna(sitep):
            continue
        siten = revcom(sitep)
        probp_tsd = 1.00
        probn_tsd = 1.00
        for i in range(0,9):
            basep = sitep[i]
            basen = siten[i]
            probp_tsd = probp_tsd*matrix[basep][i]
            probn_tsd = probn_tsd*matrix[basen][i]
        probp += probp_tsd
        probn += probn_tsd
        if probp_tsd > 0 or probn_tsd > 0:
            Np += 1
    prob = (probp + probn)/Np
    return prob

def hotspot(fastaseq, matrix, win, p, n, mping, method):
    data = []
    N = 1/p # the number of windows, which also the numebr of test we run. This need to used to correct the p-value for multi-test
    ofile = open('MSU7.mPing.HotSpot.bed' ,'w')
    for chri in sorted(fastaseq.keys()):
        seq = fastaseq[chri]
        length = len(seq)
        step = int(1*win)
        runs = int((length-win)/step)
        for i in range(runs):
            s    = i*step
            e    = s + win
            win_seq = seq[s:e]
            if not validdna(win_seq):
                continue
            p = tsd_prob(win_seq, matrix) if method == 'tsd' else p
            k = least_k(n, p, N)
            index = chri + '_' + str(s) + '_' + str(e)
            print '%s\t%s\t%s\tWin%s\t%s\t%s\t%s' %(chri, str(s), str(e), i, p, mping[index], k)
            if mping[index] >= k:
                print >> ofile, '%s\t%s\t%s\tWin%s\t100\t+\t%s\t%s' %(chri, str(s), str(e), i, mping[index], k)
                ##if mping insertion in this win large than k, then it is a hotspot 
    ofile.close()
    return data


def readtable(infile):
    data = defaultdict(str)
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2: 
                unit = re.split(r'\t',line)
                if not data.has_key(unit[0]):
                    data[unit[0]] = unit[1]
    return data


def win_mping(fastaseq, win, gff, prefix, title):
    bed = '%s.SlidingWin.bed' %(prefix)
    bar = '%s.SlidingWin.%s.density' %(prefix, title)
    if not os.path.isfile(bed):
        ofile = open(bed, 'w')
        for chri in sorted(fastaseq.keys()):
            seq = fastaseq[chri]
            length = len(seq)
            step = int(0.25*win)
            runs = int((length-win)/step) + 1
            for i in range(runs):    
                s    = int(i*0.25*win)
                e    = int(s + win)
                print >> ofile, '%s\t%s\t%s\tWin%s\t100\t+' %(chri, s, e, i)
        ofile.close()
    #Chr1    1550000 1750000 Win31   100     +       2       6       200000  0.0000300
    #                                                count   base    win     covered%
    if not os.path.isfile(bar):
        cmd = '/opt/bedtools/2.17.0-25-g7b42b3b/bin/bedtools coverage -b %s -a %s | sort -k1,1 -k2,2n > %s' %(bed, gff, bar) 
        os.system(cmd)

    data = defaultdict(lambda: int())
    with open (bar, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2: 
                unit = re.split(r'\t',line)
                index = unit[0] + '_' + unit[1] + '_' + unit[2]
                data[index] = unit[6]
    return data
 
    
def potential_tsd(fastaseq, matrix):
    N = 0 
    ofile = open('Potential.TSD.site', 'w')
    for chri in sorted(fastaseq.keys()):
        seq = fastaseq[chri]
        length = len(seq)
        win = 9
        runs = length-win-1
        probp = 0.00
        probn = 0.00
        for i in range(runs):
            s    = i
            e    = s + win
            sitep = seq[s:e]
            if not validdna(sitep):
                continue
            siten = revcom(sitep)
            probp_tsd = 1.00
            probn_tsd = 1.00
            for i in range(0,9):
                try:
                    basep = sitep[i]
                    basen = siten[i]
                    probp_tsd = probp_tsd*matrix[basep][i]
                    probn_tsd = probn_tsd*matrix[basen][i]
                except:
                    print '%s\t%s\t%s\t%s' %(s, e, sitep, siten)
                    sys.exit(2)
            if probp_tsd > 0 or probn_tsd > 0:
                print >> ofile, '%s\t%s\t%s\t%s\t%s\t%s\t%s' %(chri, str(s), str(e), sitep, str(probp_tsd), siten, str(probn_tsd))
                N += 1
    return N


def line_number(infile):
    count = 0
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2:
                count += 1 
    return count


def least_k(n, p, N):
    for i in range(1, int(n)+1):
        p_value = stats.binom_test(i, n, p)
        if p_value <= 0.05/N:
            return i        

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-r', '--ref')
    parser.add_argument('-g', '--gff')
    parser.add_argument('-t', '--type')
    parser.add_argument('-p', '--project')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.gff) > 0
    except:
        usage()
        sys.exit(2)
 
    if not args.project:
        args.project = 'Clementina'

    if not args.type:
        args.type = 'mPing'

    if not args.ref:
        args.ref = '/rhome/cjinfeng/BigData/00.RD/seqlib/MSU_r7.fa'
    ref = args.ref
    win = 200000
    method = ''
    fastaseq, g_len = fasta(ref, win)
    #matrix = readmatrix(args.input)
    #N = potential_tsd(fastaseq, matrix)
    n = line_number(args.gff)
    mping = win_mping(fastaseq, win, args.gff, args.project, args.type)
    '''
    p if the probability of having a mping in a windows of length of win by chance, so it should be 1/#win, #win=g_len/length of windows: 10000/372000000=0.0000268.
    The H0 is the observed k mping insertion in win is caused by chance and H1 is not caused by chance, which mean a hotspot.
    '''
    #p = float(win)/g_len
    #hotspot(fastaseq, matrix, win, p, n, mping, method) 

if __name__ == '__main__':
    main()


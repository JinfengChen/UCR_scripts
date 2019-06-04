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

python Summary_BUSCO.py --input ./

    '''
    print message


def runjob(script, lines):
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl --maxjob 60 --lines 2 --interval 120 --task 1 --mem 15G --time 100:00:00 --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)



def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid

'''
        1412    Complete BUSCOs (C)
        1403    Complete and single-copy BUSCOs (S)
        9       Complete and duplicated BUSCOs (D)
        3       Fragmented BUSCOs (F)
        25      Missing BUSCOs (M)
        1440    Total BUSCO groups searched
'''
def parse_busco(infile):
    data = []
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2: 
                unit = re.split(r'\t',line)
                if len(unit) == 3:
                    #print line
                    #print '%s,%s' %(unit[1], unit[2])
                    data.append(unit[1])
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
    
    s = re.compile(r'run_(.*).BUSCO')
    files = glob.glob('%s/run_*/short*' %(args.input))
    data = defaultdict(lambda : list())
    for f in files:
        name = 'genome'
        if s.search(f):
            name = s.search(f).groups(0)[0]
        f_sum = parse_busco(f)
        data[name] = f_sum
    print 'Genome\tComplete%\tFragmented%\tMissing%\t#Complete\t#Complete and single-copy\t#Complete and duplicated\t#Fragmented\t#Missing\t#Total BUSCO groups searched'
    for f in sorted(data.keys()):
        print '%s\t%0.3f\t%0.3f\t%0.3f\t%s' %(f, float(data[f][0])/int(data[f][5]), float(data[f][3])/int(data[f][5]), float(data[f][4])/int(data[f][5]), '\t'.join(data[f]))

if __name__ == '__main__':
    main()


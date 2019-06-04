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


'''
  Complete      232       93.55      -   391     1.69     44.40
   Partial      241       97.18      -   448     1.86     50.62

'''

def parse_cegma(infile):
    data = defaultdict(lambda : list())
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            line = line.lstrip()
            if len(line) > 2:
                unit = re.split(r'\s+',line)
                if line.startswith(r'Complete'): 
                    #print line
                    #print '%s,%s' %(unit[1], unit[2])
                    data['Complete'] = [unit[1], unit[2]]
                elif line.startswith(r'Partial'):
                    data['Partial']  = [unit[1], unit[2]]
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
    
    s = re.compile(r'run_(.*).CEGMA\/')
    files = glob.glob('%s/output_run_*.CEGMA/run_*.CEGMA.completeness_report' %(args.input))
    data = defaultdict(lambda : list())
    print 'Genome\tComplete\tComplete%\tPartial\tPartial%\tTotal CEGMA gene'
    for f in files:
        name = 'genome'
        if s.search(f):
            name = s.search(f).groups(0)[0]
        if os.path.getsize(f) >= 100:
            f_sum = parse_cegma(f)
            print '%s\t%s\t%s\t%s\t%s\t248' %(name, f_sum['Complete'][0], f_sum['Complete'][1], f_sum['Partial'][0], f_sum['Partial'][1])

if __name__ == '__main__':
    main()

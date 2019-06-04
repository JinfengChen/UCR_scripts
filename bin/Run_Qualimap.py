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
python Run_Qualimap.py --bam bam_dir
python Run_Qualimap.py --bam ../../input/fastq/RILs_ALL_bam_correction/

Summary bam files in input directory using qualimap

    '''
    print message

def runjob(script, lines):
    #use 2X cpu of qualimap nt, because Jordan saw qualimap use 2 when I used 1. 
    cmd = 'perl /rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl --maxjob 60 --lines %s --interval 120 --task 2 --mem 20G --time 10:00:00 --convert no %s' %(lines, script)
    #print cmd 
    os.system(cmd)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bam')
    parser.add_argument('-p', '--project')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.bam) > 0
    except:
        usage()
        sys.exit(2)


    if not args.project:
        args.project = 'Qualimap'
    sh_script = '%s.sh' %(args.project)
    ofile = open (sh_script, 'w')
    bams = glob.glob('%s/*.bam' %(os.path.abspath(args.bam)))    
    for bam in sorted(bams):
        prefix = os.path.splitext(bam)[0]
        stat   = '%s_stats' %(prefix)
        if not os.path.exists(stat):
            cmd = '/rhome/cjinfeng/BigData/software/qualimap/qualimap_v2.1.2/qualimap bamqc -bam %s --java-mem-size=16G -nt 1 -outformat PDF' %(bam)
            print >> ofile, cmd
    ofile.close()
    
    runjob(sh_script, 1)

if __name__ == '__main__':
    main()


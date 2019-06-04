#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import subprocess
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
python Sum_Qualimap.py --bam ../../input/fastq/RILs_ALL_bam_core > RILs_ALL_bam_core.summary

Summary qualimap stats in one directory

    '''
    print message

def fasta_id(fastafile):
    fastaid = defaultdict(str)
    for record in SeqIO.parse(fastafile,"fasta"):
        fastaid[record.id] = 1
    return fastaid


def parse_stats(infile):
    data = defaultdict(str)
    genomesize = 0		#number of bases
    read_number= 0		#number of reads
    read_mapped= 0		#number of mapped reads
    read_dupli = 0		#number of duplicated reads
    base_sequenced = 0		#number of sequenced bases
    base_mapped    = 0		#number of mapped bases
    insert_median  = 0		#median insert size
    map_quality    = 0.0	#mean mapping quality
    gc_percent     = 0.0	#GC percentage
    coverage_mapped= 0.0	#
    coverage_1_5   = []	        #There is a 96.88% of reference with a coverageData >= 1X
    
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            unit = re.split(r'=',line)
            word = re.split(r'\s+', line)
            if line.startswith(r'     number of bases'):
                genomesize = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     number of reads'):
                read_number = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     number of mapped reads'):
                word = re.split(r' ', unit[1])
                read_mapped = re.sub(r'\D+', r'', word[1])
            elif line.startswith(r'     number of duplicated reads'):
                read_dupli = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     number of sequenced bases'):
                base_sequenced = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     number of mapped bases'):
                base_mapped = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     median insert size'):
                insert_median = re.sub(r'\D+', r'', unit[1])
            elif line.startswith(r'     mean mapping quality'):
                map_quality   = re.sub(r'\s', r'', unit[1])
            elif line.startswith(r'     GC percentage'):
                gc_percent    = re.sub(r'\%', r'', unit[1])
            elif line.endswith(r'reference with a coverageData >= 1X'):
                coverage_mapped = re.sub(r'%', r'', word[4])
                coverage_1_5.append(word[4])
            elif line.endswith(r'reference with a coverageData >= 2X'):
                coverage_1_5.append(word[4]) 
            elif line.endswith(r'reference with a coverageData >= 3X'):
                coverage_1_5.append(word[4])
            elif line.endswith(r'reference with a coverageData >= 4X'):
                coverage_1_5.append(word[4])
            elif line.endswith(r'reference with a coverageData >= 5X'):
                coverage_1_5.append(word[4])
    #print 'genomesize, read_number, read_mapped, read_dupli'
    #print genomesize, read_number, read_mapped, read_dupli
    #print 'base_sequenced, base_mapped'
    #print base_sequenced, base_mapped
    #print 'insert_median, map_quality, gc_percent'
    #print insert_median, map_quality, gc_percent
    #print coverage_1_5
    mapped_rate = float(read_mapped)/int(read_number)
    Mapped_Depth= float(base_mapped)/int(genomesize)
    Depth       = float(Mapped_Depth)/mapped_rate
    Dupli_rate  = float(read_dupli)/int(read_number)
    
    stat = [read_number, Depth, Mapped_Depth, mapped_rate, Dupli_rate, insert_median, map_quality, gc_percent, coverage_mapped, ';'.join(coverage_1_5)]
    return stat

#return dict of ril->lib_name->bam_path
def parse_bam_all(bam_list, r):
    data = defaultdict(lambda : defaultdict(lambda : defaultdict(lambda : int())))
    for lib in sorted(re.split(r'\n', bam_list)):
        unit = re.split(r' |\t', lib)
        bam = os.path.split(unit[-1])[1]
        bam = re.sub(r'.recal.bam', r'', bam)
        bam = re.sub(r'.bam', r'', bam)
        if r.search(bam):
            ril = r.search(bam).groups(0)[0]
            #print ril, bam, unit[-1]
            data[ril][bam] = unit[-1]
            #print ril
    return data 

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bam')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.bam) > 0
    except:
        usage()
        sys.exit(2)

    r1 = re.compile(r'RIL(\d+)\_')
    bam_all = subprocess.check_output('ls -all %s/*.bam' %(os.path.abspath(args.bam)), shell=True)
    bam_inf = parse_bam_all(bam_all, r1)    

    bams = glob.glob('%s/*.bam' %(os.path.abspath(args.bam)))
    print 'Sample\t#Read\tDepth\tMapped_Depth\tMapped_rate\tDupli_rate\tInsert_median\tMap_quality\tGC_percent\tCoverage_mapped\tCoverage(1-5X)\tBamFile'
    for bam in sorted(bams):
        prefix = os.path.splitext(bam)[0]
        ril    = os.path.split(prefix)[1]
        stat   = '%s_stats/genome_results.txt' %(prefix)
        if os.path.exists(stat):
            sum_stat = parse_stats(stat)
            real_bam = os.path.basename(os.path.realpath(bam))
            #print bam, stat
            print '%s\t%s\t%s' %(ril, '\t'.join(map(str, sum_stat)), real_bam)


if __name__ == '__main__':
    main()


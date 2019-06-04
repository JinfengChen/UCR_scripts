import sys
from collections import defaultdict
import HTSeq

gtffile = HTSeq.GFF_Reader(sys.argv[1])
genes = defaultdict(lambda : str())
t = 0
for feature in gtffile:
    gene = feature.attr["gene_id"]
    genes[gene] = 1
    #print gene

print 'number of gene: %s' %(len(genes.keys()))


import sys
from Bio import SeqIO
detected = []
unique = []
for rec in SeqIO.parse(open(sys.argv[1], 'rU'), 'fastq'):
   cksum = rec.id
   #print cksum
   if cksum not in detected:
       print cksum
       unique.append(rec)
       detected.append(cksum)
SeqIO.write(unique, open(sys.argv[2],'w'), 'fastq')

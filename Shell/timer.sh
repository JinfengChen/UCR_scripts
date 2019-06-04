#!/bin/bash

start=`date +%s`

sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_3/0.te_repeat.blat.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_3/1.te_repeat.blat.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_3/2.te_repeat.blat.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_3/3.te_repeat.blat.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_4/step_4.MSU7.Chr3.repeat.align.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_5/0.repeat.findSites.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_6/0.repeat.absence.sh
sh /bigdata/cjinfeng/00.RD/RelocaTE_i/RelocaTE_i_V2.0/MSU7.Chr3.ALL.rep3_reads_10X_100_500_RelocaTEi/shellscripts/step_7/0.repeat.characterize.sh

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"


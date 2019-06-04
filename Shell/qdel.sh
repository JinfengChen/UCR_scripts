qstat -u cjinfeng | grep "30gb" | cut -d" " -f1 | sed 's/.bio//'| xargs qdel
qstat -u cjinfeng | awk '$7==12' | cut -d" " -f1 | sed 's/.bio//' | xargs qdel


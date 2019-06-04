#!/bin/bash

#lib=m130609_083056
for i in `cat file.list`
do
    lib=$i
    echo $lib
    mkdir $lib $lib/Analysis_Results
    mv $lib\_*_*_s*_p0.*.bax.h5 $lib/Analysis_Results
    mv $lib\_*_*_s*_p0.* $lib
done


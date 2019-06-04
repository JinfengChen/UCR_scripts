#!/bin/bash

#lib=m130609_083056
lib=$1
mkdir $lib $lib/Analysis_Results
mv $lib\_*_*_s*_p0.*.bax.h5 $lib/Analysis_Results
mv $lib\_*_*_s*_p0.* $lib

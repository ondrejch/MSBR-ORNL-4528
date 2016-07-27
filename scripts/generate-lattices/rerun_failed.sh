#!/bin/bash
#
# Re-submits failed jobs
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

JOBDIR="/home/ondrejch/msbr-scan/job4"
QSUB="/home/ondrejch/msbr-scan/scripts/generate-lattices/qsub.sh"

for d in $(find $JOBDIR -name done.out  -size -100c -exec ls -1 {} \; | sed -e s/done.out//g )  
do 
       echo "Re-running case: $d"
       cd $d
       rm qsub.sh.*
       qsub $QSUB
done


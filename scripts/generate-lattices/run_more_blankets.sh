#!/bin/bash
#
# Adds more blanket configurations
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL
# http://www.cyberciti.biz/faq/unix-linux-test-existence-of-file-in-bash/

OLDJOBDIR="/home/ondrejch/msbr-scan/job1"           # Original job directory
NEWJOBDIR="/home/ondrejch/msbr-scan/job1_1"         # Here we will run new jobs
DECKWRITER="/home/ondrejch/msbr-scan/MSBR-ORNL-4528/scripts/generate-lattices/write-msbr-in_dir.py"
DECKFILENAME="msbr.inp"
newRelBA="1.220 1.240 1.260 1.280 1.300 1.320"      # New relBAs to run

SAVEDIR=$(pwd)
cd $OLDJOBDIR
for d in $(find . -type d -name "gr*" )             # List of lattices to process
do 
    echo "Running cases for: $d"
    NEWBASE=${NEWJOBDIR}/$d
#    echo $NEWBASE
    for relBA in $newRelBA
    do 
        DECKDIR=${NEWBASE}/$relBA
        if ! [ -s ${DECKDIR}/${DECKFILENAME} ]      # Check if non-zero deck already exists
        then
            echo  $DECKDIR
            mkdir -p $DECKDIR
            cd $DECKDIR
            $DECKWRITER
        fi
    done 
done


cd $SAVEDIR

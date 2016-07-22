#!/usr/bin/python3
#
# Submit all jobs using TORQUE - be nice to the cluster
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import subprocess
import sys
import os
import re
import time

minqueuedjobs = 300         # Submit batch once the number of queued jobs drops below this number
jobspercycle  = 1000        # How many jobs submit per run
sleeptimer    = 60          # Check every 60 seconds

# Paths
qsubcommand  = "/home/ondrejch/msbr-scan/scripts/generate-lattices/qsub.sh"  # Location of the qsub.sh script
jobdir       = "/home/ondrejch/msbr-scan/job1/"

# Get number of running and queued jobs
def get_qsub_stats(): 
    try:
        sp_running_jobs = subprocess.check_output("qstat | grep ondrejch | grep qsub.sh | grep R | wc -l",shell=True)
    except subprocess.CalledProcessError as e:
        if e.returncode > 1:
            raise
    try:
        sp_queued_jobs  = subprocess.check_output('qstat | grep ondrejch | grep qsub.sh | grep Q | wc -l',shell=True)
    except subprocess.CalledProcessError as e:
        if e.returncode > 1:
            raise

    # Convert to integers
    my_running_jobs = int( sp_running_jobs.decode("utf-8"))
    my_queued_jobs  = int( sp_queued_jobs.decode("utf-8") )
    return ( my_running_jobs, my_queued_jobs) 

# ----------- main program starts here ----------------------

# Get list of jobs to run
try:
    list_jobs2run = subprocess.check_output("find " + jobdir + " -name msbr.inp| sed s/msbr.inp$//g | sort",shell=True).splitlines()
except subprocess.CalledProcessError as e:
    if e.returncode > 1:
        raise
no_jobs2run  = len( list_jobs2run )

# Main loop
ijob = 0
ijobsubmax = -999
finished = False
while not finished:
    (running_jobs, queued_jobs) = get_qsub_stats()
    if (queued_jobs < minqueuedjobs):
        # Submit jobs
        ijobsubmax = min(ijob+jobspercycle, no_jobs2run)
        for i in range(ijob, ijobsubmax):
            dirname = list_jobs2run[i].decode("utf-8")
            os.system('cd ' + dirname + ';  qsub ' + qsubcommand) 
        ijob = ijobsubmax
    if(ijobsubmax == no_jobs2run):
        finished = True
    else: 
        print("Submitted ",ijob," jobs, sleeping ")
        time.sleep(sleeptimer)

print ("All done")

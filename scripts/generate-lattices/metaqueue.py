#! python3
#
# Submit jobs using Grid Engine - be nice to the cluster
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import subprocess
import sys
import os
import time
import platform

minqueuedjobs = 300         # Submit batch once the number of queued jobs drops below this number
jobspercycle  = 1000        # How many jobs submit per run
sleeptimer    = 60          # Check every 60 seconds

# Paths
jobnumber       = 'jobX/'   # Job directory tree 
if 'necluster' in platform.node() :
    qsubcommand = "/home/ondrejch/msbr-scan/scripts/generate-lattices/qsub.sh" # Location of qsub.sh script
    jobdir      = "/home/ondrejch/msbr-scan/" + jobnumber                      # Where to run the jobs
    checkrunning= "qstat | grep ondrejch | grep qsub.sh | grep R | wc -l"      # Shell command to get # of running jobs on Torque
    checkqueued = "qstat | grep ondrejch | grep qsub.sh | grep Q | wc -l"      # Shell command to get # of running jobs on Torque
elif 'sigma' in platform.node() :
    qsubcommand = "/data/home/ochvala/play/scripts/qsub.sh"
    jobdir      = "/lustre/scratch/ochvala/" + jobnumber
    checkrunning= "qstat | grep ochvala | grep ornl4528 | grep ' r ' | wc -l"  # Shell command to get # of running jobs on GridEngine
    checkqueued = "qstat | grep ochvala | grep ornl4528 | grep  qw   | wc -l"  # Shell command to get # of running jobs on GridEngine
else:
    qsubcommand = "/bin/false"
    jobdir      = "/tmp/" + jobnumber
    checkrunning= "/bin/false"
    checkqueued = "/bin/false"
    

# Get number of running and queued jobs
def get_qsub_stats(): 
    try:
        sp_running_jobs = subprocess.check_output(checkrunning,shell=True)
        my_running_jobs = int( sp_running_jobs.decode("utf-8"))     # Convert to integers
    except subprocess.CalledProcessError as e:
        if e.returncode > 1:
            my_running_jobs = -999
    try:
        sp_queued_jobs  = subprocess.check_output(checkqueued,shell=True)
        my_queued_jobs  = int( sp_queued_jobs.decode("utf-8") )     # Convert to integers
    except subprocess.CalledProcessError as e:
        if e.returncode > 1:
            my_queued_jobs = -999
    
    return ( my_running_jobs, my_queued_jobs ) 

# ----------- main program starts here ----------------------

# Get list of jobs to run
try:
#    list_jobs2run = subprocess.check_output("find " + jobdir + " -name msbr.inp| sed s/msbr.inp$//g | sort",shell=True).splitlines()
    list_jobs2run = subprocess.check_output("find " + jobdir + " -mindepth 4 -maxdepth 4 -type d '!' -exec test -e \"{}/msbr.inp_res.m\" ';' -print| sort",shell=True).splitlines()
except subprocess.CalledProcessError as e:
    if e.returncode > 1:
        print("Error: cannot get # of jobs to run!")
        sys.exit(e.returncode)
        
no_jobs2run  = len( list_jobs2run )

# Main loop
ijob = 0
ijobsubmax = -999
finished = False
while not finished:
    (running_jobs, queued_jobs) = get_qsub_stats()
    if (running_jobs < 0) or (queued_jobs < 0):
        print("Cannot communicate with the scheduler, sleeping")
        time.sleep(sleeptimer)
        continue
    
    if queued_jobs < minqueuedjobs :
        # Submit jobs
        ijobsubmax = min(ijob+jobspercycle, no_jobs2run)
        for i in range(ijob, ijobsubmax):
            dirname = list_jobs2run[i].decode("utf-8")
            os.system('cd ' + dirname + ';  qsub ' + qsubcommand) 
        ijob = ijobsubmax
    if ijobsubmax == no_jobs2run :
        finished = True
    else: 
        print("Submitted ",ijob," jobs; running ", running_jobs," and queued ", queued_jobs, "jobs.")
        time.sleep(sleeptimer)

print ("All done")

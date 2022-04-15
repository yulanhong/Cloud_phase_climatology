#!/bin/bash

#PBS -N myjob10

#PBS -l nodes=1:ppn=1

#PBS -l walltime=5:30:00

# combine PBS standard output and error files

#PBS -j oe

# mail is sent to you when the job starts and when it terminates or aborts

#PBS -m bea

# specify your email address

#PBS -M yulanh@illinois.edu

#change to the directory where you submitted the job

cd $PBS_O_WORKDIR

#include the full path to the name of your MPI program

aprun -n 1 ./test08

exit 0

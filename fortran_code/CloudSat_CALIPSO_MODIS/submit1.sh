#!/bin/bash

#PBS -N myjob201012

#PBS -l nodes=15:ppn=32

#PBS -l walltime=01:00:00

# combine PBS standard output and error files

#PBS -j oe

# mail is sent to you when the job starts and when it terminates or aborts

#PBS -m bea

# specify your email address

##PBS -M yulanh@illinois.edu

#change to the directory where you submitted the job

cd $PBS_O_WORKDIR

#include the full path to the name of your MPI program

cld_date="200702"

echo "$cld_date" | aprun -n Nnodes ./Radiate10

exit 0

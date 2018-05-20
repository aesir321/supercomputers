#!/bin/bash
#@ wall_clock_limit = 00:30:00
#@ job_name = pos-lulesh-openmp
#@ job_type = MPICH
#@ notification = never
#@ class = test
#@ initialdir = $(home)/programming-of-supercomputers/assignment_1
#@ output = data/task4.1.1/pos_lulesh_gprof_$(jobid).out
#@ error = data/task4.1.1/pos_lulesh_gprof_$(jobid).out
#@ node = 1
#@ total_tasks = 28
#@ node_usage = not_shared
#@ energy_policy_tag = lulesh
#@ island_count = 1
#@ minimize_time_to_solution = yes 
#@ queue
. /etc/profile
. /etc/profile.d/modules.sh

module unload mpi.ibm
module load mpi.intel
module list
module load gcc/5

export OMP_NUM_THREADS=16
./code/task4.1/lulesh2.0/lulesh2.0
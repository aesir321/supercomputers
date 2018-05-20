#!/bin/bash
#@ wall_clock_limit = 00:10:00
#@ job_name = pos-lulesh-openmp
#@ job_type = MPICH
#@ notification = never
#@ class = test
#@ output = pos_lulesh_pragma_phase2_$(jobid).out
#@ error = pos_lulesh_pragma_phase2_$(jobid).out
#@ node = 1
#@ total_tasks = 16
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

export OMP_NUM_THREADS=28

./lulesh2.0
./lulesh_ivdep

#!/bin/bash
#@ wall_clock_limit = 00:10:00
#@ job_name = pos-lulesh-openmp
#@ job_type = MPICH
#@ class = micro
#@ output = pos_lulesh_openmp_$(jobid).out
#@ error = pos_lulesh_openmp_$(jobid).out
#@ node = 1
#@ total_tasks = 16
#@ node_usage = not_shared
#@ energy_policy_tag = lulesh
#@ minimize_time_to_solution = yes
#@ island_count = 1
#@ queue
module load intel/16.0
. /etc/profile
. /etc/profile.d/modules.sh
export OMP_NUM_THREADS=16
./lulesh2.0

#!/bin/bash
#@ wall_clock_limit = 00:10:00
#@ job_name = pos-lulesh-openmp
#@ job_type = MPICH
#@ class = test
#@ initialdir = $(home)/programming-of-supercomputers/assignment_1
#@ output = data/task5.3/pos_lulesh_hybrid_phase2_$(jobid).out
#@ error = data/task5.3/pos_lulesh_hybrid_phase2_$(jobid).out
#@ node = 1
#@ total_tasks = 28
#@ node_usage = not_shared
#@ energy_policy_tag = lulesh
#@ minimize_time_to_solution = yes
#@ island_count = 1
#@ queue

. /etc/profile
. /etc/profile.d/modules.sh
. $HOME/.bashrc

module unload mpi.ibm
module load mpi.intel
module load intel/16.0
module list

export OMP_NUM_THREADS=1
mpiexec -n 1 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=2
mpiexec -n 1 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=4
mpiexec -n 1 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=8
mpiexec -n 1 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=16
mpiexec -n 1 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=1
mpiexec -n 8 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=2
mpiexec -n 8 ./code/task5.3/lulesh2.0/lulesh2.0

export OMP_NUM_THREADS=1
mpiexec -n 27 ./code/task5.3/lulesh2.0/lulesh2.0

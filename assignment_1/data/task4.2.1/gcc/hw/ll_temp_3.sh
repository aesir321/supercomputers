#!/bin/bash
#@ wall_clock_limit = 00:30:00
#@ job_name = pos-lulesh-openmp
#@ job_type = MPICH
#@ notification = always
#@ notify_user = parkerwill625@gmail.com
#@ class = test
#@ initialdir = $(home)/programming-of-supercomputers/assignment_1
#@ output = data/task4.2.1/pos_lulesh_seq_$(jobid).out
#@ error = data/task4.2.1/pos_lulesh_seq_$(jobid).out
#@ node = 1
#@ total_tasks = 16
#@ node_usage = not_shared
#@ energy_policy_tag = lulesh
#@ island_count = 1
#@ minimize_time_to_solution = yes 
#@ queue
. /etc/profile
. /etc/profile.d/modules.sh
export OMP_NUM_THREADS=16
module unload mpi.ibm
module load mpi.intel
module list
module load gcc/5
./bin/gcc/lulesh2.0_4_32
./bin/gcc/lulesh2.0_4_33
./bin/gcc/lulesh2.0_4_34
./bin/gcc/lulesh2.0_5_0
./bin/gcc/lulesh2.0_5_1
./bin/gcc/lulesh2.0_5_2
./bin/gcc/lulesh2.0_5_3
./bin/gcc/lulesh2.0_5_4
./bin/gcc/lulesh2.0_5_5
./bin/gcc/lulesh2.0_5_6
./bin/gcc/lulesh2.0_5_7
./bin/gcc/lulesh2.0_5_8
./bin/gcc/lulesh2.0_5_9
./bin/gcc/lulesh2.0_5_10
./bin/gcc/lulesh2.0_5_11
./bin/gcc/lulesh2.0_5_12
./bin/gcc/lulesh2.0_5_13
./bin/gcc/lulesh2.0_5_14
./bin/gcc/lulesh2.0_5_15
./bin/gcc/lulesh2.0_5_16
./bin/gcc/lulesh2.0_5_17
./bin/gcc/lulesh2.0_5_18
./bin/gcc/lulesh2.0_5_19
./bin/gcc/lulesh2.0_5_20
./bin/gcc/lulesh2.0_6_0
./bin/gcc/lulesh2.0_6_1
./bin/gcc/lulesh2.0_6_2
./bin/gcc/lulesh2.0_6_3
./bin/gcc/lulesh2.0_6_4
./bin/gcc/lulesh2.0_6_5
./bin/gcc/lulesh2.0_6_6
./bin/gcc/lulesh2.0_7_0

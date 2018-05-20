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
./bin/gcc/lulesh2.0_4_0
./bin/gcc/lulesh2.0_4_1
./bin/gcc/lulesh2.0_4_2
./bin/gcc/lulesh2.0_4_3
./bin/gcc/lulesh2.0_4_4
./bin/gcc/lulesh2.0_4_5
./bin/gcc/lulesh2.0_4_6
./bin/gcc/lulesh2.0_4_7
./bin/gcc/lulesh2.0_4_8
./bin/gcc/lulesh2.0_4_9
./bin/gcc/lulesh2.0_4_10
./bin/gcc/lulesh2.0_4_11
./bin/gcc/lulesh2.0_4_12
./bin/gcc/lulesh2.0_4_13
./bin/gcc/lulesh2.0_4_14
./bin/gcc/lulesh2.0_4_15
./bin/gcc/lulesh2.0_4_16
./bin/gcc/lulesh2.0_4_17
./bin/gcc/lulesh2.0_4_18
./bin/gcc/lulesh2.0_4_19
./bin/gcc/lulesh2.0_4_20
./bin/gcc/lulesh2.0_4_21
./bin/gcc/lulesh2.0_4_22
./bin/gcc/lulesh2.0_4_23
./bin/gcc/lulesh2.0_4_24
./bin/gcc/lulesh2.0_4_25
./bin/gcc/lulesh2.0_4_26
./bin/gcc/lulesh2.0_4_27
./bin/gcc/lulesh2.0_4_28
./bin/gcc/lulesh2.0_4_29
./bin/gcc/lulesh2.0_4_30
./bin/gcc/lulesh2.0_4_31

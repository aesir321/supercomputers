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
./bin/gcc/lulesh2.0_3_3
./bin/gcc/lulesh2.0_3_4
./bin/gcc/lulesh2.0_3_5
./bin/gcc/lulesh2.0_3_6
./bin/gcc/lulesh2.0_3_7
./bin/gcc/lulesh2.0_3_8
./bin/gcc/lulesh2.0_3_9
./bin/gcc/lulesh2.0_3_10
./bin/gcc/lulesh2.0_3_11
./bin/gcc/lulesh2.0_3_12
./bin/gcc/lulesh2.0_3_13
./bin/gcc/lulesh2.0_3_14
./bin/gcc/lulesh2.0_3_15
./bin/gcc/lulesh2.0_3_16
./bin/gcc/lulesh2.0_3_17
./bin/gcc/lulesh2.0_3_18
./bin/gcc/lulesh2.0_3_19
./bin/gcc/lulesh2.0_3_20
./bin/gcc/lulesh2.0_3_21
./bin/gcc/lulesh2.0_3_22
./bin/gcc/lulesh2.0_3_23
./bin/gcc/lulesh2.0_3_24
./bin/gcc/lulesh2.0_3_25
./bin/gcc/lulesh2.0_3_26
./bin/gcc/lulesh2.0_3_27
./bin/gcc/lulesh2.0_3_28
./bin/gcc/lulesh2.0_3_29
./bin/gcc/lulesh2.0_3_30
./bin/gcc/lulesh2.0_3_31
./bin/gcc/lulesh2.0_3_32
./bin/gcc/lulesh2.0_3_33
./bin/gcc/lulesh2.0_3_34

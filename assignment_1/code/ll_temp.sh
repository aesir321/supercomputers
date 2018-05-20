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
./bin/gcc/lulesh2.0_0_0
./bin/gcc/lulesh2.0_1_0
./bin/gcc/lulesh2.0_1_2
./bin/gcc/lulesh2.0_2_1
./bin/gcc/lulesh2.0_1_1
./bin/gcc/lulesh2.0_1_3
./bin/gcc/lulesh2.0_1_4
./bin/gcc/lulesh2.0_1_5
./bin/gcc/lulesh2.0_1_6
./bin/gcc/lulesh2.0_2_0
./bin/gcc/lulesh2.0_2_2
./bin/gcc/lulesh2.0_2_3
./bin/gcc/lulesh2.0_2_4
./bin/gcc/lulesh2.0_2_5
./bin/gcc/lulesh2.0_2_6
./bin/gcc/lulesh2.0_2_7
./bin/gcc/lulesh2.0_2_8
./bin/gcc/lulesh2.0_2_9
./bin/gcc/lulesh2.0_2_10
./bin/gcc/lulesh2.0_2_11
./bin/gcc/lulesh2.0_2_12
./bin/gcc/lulesh2.0_2_13
./bin/gcc/lulesh2.0_2_14
./bin/gcc/lulesh2.0_2_15
./bin/gcc/lulesh2.0_2_16
./bin/gcc/lulesh2.0_2_17
./bin/gcc/lulesh2.0_2_18
./bin/gcc/lulesh2.0_2_19
./bin/gcc/lulesh2.0_2_20
./bin/gcc/lulesh2.0_3_0
./bin/gcc/lulesh2.0_3_1
./bin/gcc/lulesh2.0_3_2
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

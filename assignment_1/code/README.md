# Useage

In order to generate the binaries and compiler flag combinations follow the following steps:

1. cd ~/programming-of-supercoputers/assignment_1/

2. python code/compiler_flags.py <compiler version: either gcc or intel> For example:
   python code/compiler_flags.py gcc
   
3. The data files will be stored in data/task4.2.1/ with the naming convention: pos_lulesh_(jobid).out

4. The results files then need to be parsed to get the speed up run the following command:
   python code/parse_results.py 'results_file1.out results_file2.out ...'
   The order of the results files matter, they should match the order in which the binaries were submitted. 
   This is normally the same order as the time created of the files due to the scheduler.
   
5. The computed results file should now exist in the data/task4.2.1 directory with the name:
   results_file1_file2_..._filen.dat
   
6. It is recommended that after running the .out files and generated results be copied to the corresponding directory
   For example for an intel run on sb the files should be copied to: data/task4.2.1/intel/sb/

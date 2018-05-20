import matplotlib.pyplot as plt
import numpy as np
import sys
import re

def get_grind_time(file1):
    grind_times = []
    fom = []
    with open(file1, 'r') as f:
        
        lines = f.readlines()
        for line in lines:
            if line.startswith('Grind time (us/z/c)'): # line has our data!
                g_results = re.findall(r'\d.+', line.split('(')[3])[0]
                grind_times.append(float(g_results.split()[0]))
            elif line.startswith('FOM'):
                f_results = re.findall(r'\d.+', line)[0]
                fom.append(float(f_results.split('(')[0]))

    return grind_times, fom

fig1 = plt.figure()
open_mp_threads_1 = [1, 2, 4, 8, 16]
openmp_1_grind, fom = get_grind_time('../data/task5.1/pos_lulesh_openmp_phase1_2043483.out')
plt.scatter(open_mp_threads_1, openmp_1_grind, label='Phase 1')
open_mp_threads_2 = [1, 2, 4, 8, 16]
openmp_2_grind, fom = get_grind_time('../data/task5.1/pos_lulesh_openmp_phase2_713803.out')
plt.scatter(open_mp_threads_2, openmp_2_grind, label='Phase 2')
plt.title('A plot to show how increasing the number of threads in \n OpenMP affects the grind time of the Lulesh 2.0.3 benchmark.')
plt.xlabel('Number of threads')
plt.ylabel('Overall grind time / (us/z/c)')
plt.legend()
plt.savefig('openmp.png', bbox_inches='tight')

fig2 = plt.figure()
mpi_processes_1 = [1, 8]
mpi_grind_1, mpi_fom_1 = get_grind_time('../data/task5.2/pos_lulesh_mpi_phase1_2019225.out')
plt.scatter(mpi_processes_1, mpi_grind_1, label='Phase 1')

mpi_processes_2 = [1, 8, 27]
mpi_grind_2, mpi_fom_2 = get_grind_time('../data/task5.2/pos_lulesh_mpi_phase2_713815.out')
plt.scatter(mpi_processes_2, mpi_grind_2, label='Phase 2')
plt.xlabel('Number of processes')
plt.ylabel('Overall grind time / (us/z/c)')
plt.title('A plot to show how increasing the number of processes \n in MPI affects the grind time of the Lulesh 2.0.3 benchmark')
plt.legend()
plt.savefig('mpi.png', bbox_inches='tight')

#fig3 = plt.figure()
#plt.scatter(mpi_processes_1, [x / 1000.0 for x in mpi_fom_1], label='FOM')
#plt.scatter(mpi_processes_1, mpi_grind_1, label='Grind time')
#plt.xlabel('Number of processes')
#plt.legend()
#plt.savefig('mpi_grind_fom.png')

#fig4 = plt.figure()
#plt.scatter(mpi_processes_2, [x / 1000.0 for x in mpi_fom_2], label='FOM')
#plt.scatter(mpi_processes_2, mpi_grind_2, label='Grind time')
#plt.xlabel('Number of processes')
#plt.legend()
#plt.savefig('mpi_grind_fom2.png')

hybrid_processes_threads_1 = [1, 2, 3, 4, 5, 6, 7]
hybrid_processes_threads_2 = [1, 2, 3, 4, 5, 6, 7, 8]
hybrid_grind_1, hybrid_fom_1 = get_grind_time('../data/task5.3/pos_lulesh_hybrid_phase1_2043730.out')
hybrid_grind_2, hybrid_fom_2 = get_grind_time('../data/task5.3/pos_lulesh_hybrid_phase2_713897.out')
fig5 = plt.figure()
plt.scatter(hybrid_processes_threads_1, hybrid_grind_1, label='Phase 1')
plt.scatter(hybrid_processes_threads_2, hybrid_grind_2, label='Phase 2')
plt.xlabel('Number of threads and processes')
plt.ylabel('Overall grind time (us/z/c)')

labs = ['1 thread 1 process',
        '2 threads 1 process',
        '4 threads 1 process',
        '8 threads 1 process',
        '16 threads 1 process',
        '1 thread 8 processes',
        '2 threads 8 processes',
        '1 thread 16 processes']

plt.xticks(hybrid_processes_threads_2, labs, rotation='vertical')
plt.title('A plot to show the relationship between the grind time and the \n change of threads and processes in a \n  hybrid run of the Lulesh 2.0.3 benchmark')
plt.legend()
plt.savefig('hybrid.png', bbox_inches='tight')

def get_speedup(file1):
    lines = []
    with open(file1, 'r') as f:
        lines = f.readlines()

    labels = [x.split(',')[0] for x in lines]
    speedups = [x.split(',')[-1] for x in lines]
    x = range(1, len(labels) + 1)
    return labels, speedups, x

fig7 = plt.figure()
ihw_labels, ihw_speedups, ihw_x = get_speedup('../data/task4.2.1/intel/hw/results/speedups.dat')
isb_labels, isb_speedups, isb_x = get_speedup('../data/task4.2.1/intel/sb/results/speedups.dat')
plt.scatter(ihw_x, ihw_speedups, label='Phase 2')
plt.scatter(isb_x, isb_speedups, label='Phase 1')
plt.xticks(ihw_x, ihw_labels, rotation='vertical')
plt.title('A Plot showing how different combinations of intel compiler flags affect overrall run time.')
plt.xlabel('Compiler flags')
plt.ylabel('Speedup / s')
plt.legend()
plt.savefig('intel_sbhw_flags.png', bbox_inches='tight')

fig8 = plt.figure()
ghw_labels, ghw_speedups, ghw_x = get_speedup('../data/task4.2.1/gcc/hw/results/speedups.dat')
gsb_labels, gsb_speedups, gsb_x = get_speedup('../data/task4.2.1/gcc/sb/results/speedups.dat')
plt.scatter(ghw_x, ghw_speedups, label='Phase 2')
plt.scatter(gsb_x, gsb_speedups, label='Phase 1')
plt.title('A Plot showing how different combinations of gcc compiler flags affect overrall run time.')
plt.xlabel('Compiler flags')
plt.ylabel('Speedup / s')
plt.legend()
plt.savefig('gcc_sbhw_flags.png', bbox_inches='tight')

with open('gcc_key.txt', 'w') as f:
    for i, l in enumerate(ghw_labels):
        f.write(str(i + 1) + '='+l +'\n')


#!/usr/bin/python
import itertools
from subprocess import call
import os
from os.path import isfile, join
import time
import sys

gnu_flags = ['-march=native',
            '-fomit-frame-pointer',
            '-floop-block',
            '-floop-interchange',
            '-floop-strip-mine',
            '-funroll-loops',
            '-flto']

intel_flags = ['-march=native',
               '-xHost',
               '-unroll',
               '-ipo']

makefile_path = os.path.join(os.getcwd(), 'lulesh2.0/Makefile')
gcc = True
c_flags = None
binaries = []

def load_modules():
    call('module unload mpi.ibm/1.4', shell=True)
    call('module load mpi.intel', shell=True)
    call('module unload gcc', shell=True)
    global c_flags
    global gcc
    if sys.argv[1] == 'gcc':
        c_flags = gnu_flags
        call('module load gcc/5', shell=True)
        gcc = True
    else:
        c_flags = intel_flags
        call('module load intel/16.0', shell=True)
        gcc = False

def read_makefile_to_list():
    with open(makefile_path, 'r') as f:
        lines = list(f)
    return lines

def execute_shell_commands(i, j, flags):
    os.chdir('lulesh2.0')
    call('make clean && make', shell=True)
    new_binary = 'lulesh2.0_' + str(i) + '_' + str(j)
    if gcc:
        call('cp lulesh2.0 ../bin/gcc/' + new_binary, shell=True)
    else:
        call('cp lulesh2.0 ../bin/intel/' + new_binary, shell=True)
    os.chdir('../')
    global binaries
    binaries.append(new_binary + '_' + flags)

def process_binaries(lines):
    # Can maybe separate combs out?
    for i, flag in enumerate(range(0, len(c_flags) + 1)):
        for j, subset_flags in enumerate(itertools.combinations(c_flags, flag)):
            with open(makefile_path, 'w') as output:
                for line in lines:
                    if line.startswith('SERCXX ='):
                        if gcc:
                            output.write('SERCXX = g++ -DUSE_MPI=0\n')
                        else:
                            output.write('SERCXX = icc -DUSE_MPI=0\n') 
                    elif line.startswith('CXXFLAGS = '):
                        flags = ''
                        for f in subset_flags:
                            flags += (' ' + f)
                        output.write('CXXFLAGS = -O3 -I. -w' + flags + '\n')
                    else:
                        output.write(line)
            
            execute_shell_commands(i, j, flags)

    with open('data/task4.2.1/binaries.key', 'w') as f:
        for b in binaries:
            f.write(b + '\n')
            
def split_list(l, parts):
    length = len(l)
    return [l[i*length / parts: (i+1)*length / parts]
            for i in range(parts)]

def queue_job():
    lines = []

    with open('code/ll_sequential.sh', 'r') as f:
        lines = f.readlines()

        if gcc:
            p = 'bin/gcc'
            compiler = '\nmodule load gcc/5\n'
            binaries = [b for b in os.listdir(p) if isfile(join(p, b))]

            split_binaries = split_list(binaries, 4) # 4 as we have max 30 mins and each binary takes ~40 secs.  128 binaries total

            for i, binaries in enumerate(split_binaries):            
                with open('code/ll_temp_' + str(i) + '.sh', 'w') as gcc_f:
                    [gcc_f.write(line) for line in lines]
                    gcc_f.write(compiler)
                    [gcc_f.write('./' + p + '/' + b + '\n') for b in binaries]

            os.chdir('code')
            [call(['llsubmit ll_temp_' + str(i) + '.sh'], shell=True) for i in range(len(split_binaries))]
            os.chdir('../')
        else:
            with open('code/ll_temp.sh', 'w') as intel_f:
                p = 'bin/intel'
                compiler = '\nmodule load intel/16.0\n'
                binaries = [b for b in os.listdir(p) if isfile(join(p, b))]
                [intel_f.write(line) for line in lines]
                intel_f.write(compiler)
                [intel_f.write('./' + p + '/' + b + '\n') for b in binaries]

            os.chdir('code')
            call(['llsubmit ll_temp.sh'], shell=True)
            os.chdir('../')

#load_modules()
#lines = read_makefile_to_list()
#process_binaries(lines)
queue_job()

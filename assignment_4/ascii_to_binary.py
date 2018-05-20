from os import listdir
from os.path import isfile, join

path = 'cannon_matrices'
files = [join(path, f) for f in listdir(path) if isfile(join(path, f))]

for file_to_convert in files:
    string_list = []
    new_file_name = file_to_convert.replace('.in', '_bin.in')
    print "Converting " + file_to_convert + " to " +  new_file_name + "\n"
    with open(file_to_convert, 'r') as f:
        string = (' '.join(format(ord(x), 'b') for x in f.read()))
        string_list = string.split()

    with open(new_file_name, 'w') as f:
        for line in string_list:
            f.write(line + ' ')



    

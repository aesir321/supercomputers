#/bin/bash

for f in Makefile*;
do
echo $f
cp $f Makefile;
make clean;
make;
cat Makefile | grep "CXX" >> time.txt;
time ./lulesh2.0 | grep "Elapsed" >> time.txt;
done

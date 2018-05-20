#!/usr/bin/perl

#process raw output from multiple instance loadleveler cannon run

use warnings;
use strict;

my $input_file = $ARGV[0];
open (my $FH, '<', $input_file)
	or die "Cant open file $!\n"; 

my $reading = 0;
my $tstamp;
my @record;

print "Matrix_size Comp_time   MPI_time  Init_time  Output_time  Real_time\n";   

foreach my $line (<$FH>) {
	if ($line =~ m/^(\d{19})/ && $reading == 0) {
            #this is a new reading, beginning of the file
            $reading = 1;
            $tstamp = $1;  
            #print "$1\n";
	}
	if ($line =~ m/\((\d+),\d+\).*/) {
            push @record, $1;
	}
	if ($line =~ m/Computation\stime:\s+(\d+\.\d+).*/) {
            #print "$1\n";
            push @record, $1;
	}
	if ($line =~ m/MPI\stime:\s+(\d+\.\d+).*/) {
            #print "$1\n";
            push @record, $1;
	}
	if ($line =~ m/Initialisation\stime:\s(\d+\.\d+).*/){
		push @record, $1;
	}
	if ($line =~ m/Output\stimeL\s(\d+\.\d+).*/){
		push @record, $1;
	}
	if ($line =~ m/^(\d{19})/ && $reading == 1) {
            #we're at the end of a record and the beginning of a new one
            my $end_time = $1;
            my $dif = ($end_time - $tstamp)/1000000000;
            $tstamp = $end_time;
            push @record, $dif;
            #print"$dif\n";
            print "@record\n";
            @record = ();  #empty the array
	}
}

#!/usr/bin/perl
use Math::Combinatorics;
use DirHandle;
use strict;
use warnings;

my $base_flags = '-g -O3 -I. -Wall';

my @flags = (
	'-floop-block',
	'-floop-interchange',
	'-floop-strip-mine',
	'-funroll-loops',
	'-march=native',
	'-fomit-frame-pointer',
	'-flto' );



#global array to hold all flag combinations	
my @all_flags;

#get all the combinations
	for (my $n = 1; $n <= 7; $n++) { 
		my @combined = combine($n, @flags);
		my @joined = map { join (" ", @$_) } @combined;
		push @all_flags, @joined;
        }

    
my $filename = "../lulesh2.0/Makefile";
#my $d = DirHandle->("../lulesh2.0/");
#system("cd ../lulesh2.0/");
chdir("../lulesh2.0/") or die "Cannot change: $!\n";

for my $counter (0 .. $#all_flags) {
    my $new_filename = "$filename$counter";
    my $data = read_file($filename);
    $data =~ s/(CXXFLAGS.*)\n/$1 $all_flags[$counter] \n/g;
    write_file($new_filename, $data);

    
    print "\n---------------------Compiling lulesh_trial_$counter-----------------\n\n";
    print "--------Using flags: $all_flags[$counter]\n\n";
    system("pwd");
    system("make clean");
    system("make -f $new_filename");
    system("mv lulesh2.0 lulesh_trial_$counter");
    system("rm $new_filename"); 
    print "\n--------------------Finished compiling trial $counter --------------------- \n";
}


sub read_file {
    my ($filename) = @_;
 
    open my $in, '<', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;
    return $all;
}

sub write_file {
    my ($filename, $content) = @_;
    open my $out, '>', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;
    return;
}


#print join "\n", map { join " ", @$_ } @deg;

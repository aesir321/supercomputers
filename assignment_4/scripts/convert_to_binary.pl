#!/usr/bin/perl

use strict;
use warnings;

##converts ASCII to binary

if (@ARGV < 1) {
  print STDERR "Usage: $0 FILENAME\n";
  exit 1;
}

my $input_name = $ARGV[0];
my $output_name = $input_name;
$output_name =~ s/(.*)\.in/$1_bin\.in/;
print "converting $input_name to $output_name\n";

#open the input and output files
open (my $in_FH, '<', $input_name) 
	or die "Unable to open input file: $!";

open(my $out_FH, '>:raw', "$output_name") 
	or die "Unable to open output file: $!";

#allegedly takes care of carrage returns from windows systems
#$out_FH->binmode; 

# define different datatypes
my @size;
my @elements;

#load the data from the file
my $counter = 0;
while (my $line = <$in_FH>) {
	chomp $line;
	if ($counter == 0) {
		push @size, split(/\s+/, $line);
		$counter += 1;	
	}
	else {
		push @elements, split(/\s+/, $line);
		$counter += 1;
	}
}

#write the binary data being careful to specify datatypes
my $num_doubles = $#elements + 1;
my $binary = pack "i2 d$num_doubles", @size, @elements; 
print $out_FH "$binary"; 

#close the input and output file handles
close $in_FH;
close $out_FH;


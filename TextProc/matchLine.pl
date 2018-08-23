#
# Name:     matchLine.pl
# Author:   Jared Knutson
# Ability:  This script has the ability to take as input a text file
#           and print out the word frequency, using hashes.
#
#!/usr/bin/perl
#
use strict;
use warnings;

my ($qfn_in, $search) = @ARGV;
open(my $fh_in, '<', $qfn_in)
    or die("Unable to read file \"$qfn_in\": $!\n");

while (<$fh_in>) {
    if (/$search/) {
        print $_;
    }
}


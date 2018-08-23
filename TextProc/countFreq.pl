#
# Name:     countFreq.pl
# Author:   Jared Knutson
# Ability:  This script has the ability to take as input a text file
#           and print out the word frequency, using hashes.
#

# To help find typos in variable names.
use strict; use warnings;

# Create a hash called count.
my %count;
# Create a variable to hold the file name, read this from the command line arguments.
my $file = shift or die "Usage: $0 FILE\n";

# Open a file for reading using the $file variables or exit in error.
open my $fh, '<', $file or die "Could not open '$file' $!";

# Pull out line by line until the end of the file using a while loop.
while (my $line = <$fh>) {
    # Pass through functions; "We're slicing and Dicing StRiNgS"
    # 1. Convert letters to lowercase.
    # 2. Pull out punctuation using sed.
    $line = lc $line;
    $line =~ s/[\.\;\,\n\[\]\(\)\-\"\&\/]//g;

    # For each string delimited by a space, (word), increment the value based on its key.
    foreach my $str (split /\s+/, $line) {
        $count{$str}++;
    }
}

# Print the key and value for each of the matched items. 
# $a and $b are placeholder variables for sort
# Spaceship operator treats the values of the hash as numbers instead of strings before attempting to sort them.
# The or case is a last resort if the spaceship operator returns 0 then the cmp operator gets a chance to compare the two values.
foreach my $str (sort { $count{$a} <=> $count{$b} or $a cmp $b} keys %count) {
    printf "%-31s %s\n", $str, $count{$str};
}

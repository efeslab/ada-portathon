#!/usr/bin/perl
#
# Test write image method on JBIG image
#
# Contributed by Bob Friesenhahn <bfriesen@simple.dallas.tx.us>
#
BEGIN { $| = 1; $test=1; print "1..1\n"; }
END {print "not \n" unless $loaded;}

use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't/jbig' || die 'Cd failed';

testReadWrite( 'input.jbig',
  'output.jbig',
  '',
  '38e9b7c1b5b0eb3a8c95621ded1545b90f31f8962347489212de0a6ebd1bc8d4' );

$test=0; # Keep perl from complaining

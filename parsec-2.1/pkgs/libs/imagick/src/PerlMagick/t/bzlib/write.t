#!/usr/bin/perl
#
# Test writing files using bzlib-based compression
#
# Contributed by Bob Friesenhahn <bfriesen@simple.dallas.tx.us>
#
BEGIN { $| = 1; $test=1; print "1..1\n"; }
END {print "not ok $test\n" unless $loaded;}

use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't/bzlib' || die 'Cd failed';

#
# Test writing BZip-compressed MIFF
#

testReadWrite( 'input.miff',
  'output.miff',
  q/compression=>'BZip'/,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e' );

$test = 0;  # Quench PERL compliaint


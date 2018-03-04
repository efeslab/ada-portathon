#!/usr/bin/perl
#
# Test writing FPX images
#
# Contributed by Bob Friesenhahn <bfriesen@simple.dallas.tx.us>
#
BEGIN { $| = 1; $test=1; print "1..4\n"; }
END {print "not ok $test\n" unless $loaded;}

use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't/fpx' || die 'Cd failed';

#
# 1) Test Black-and-white, bit_depth=1 FPX
# 
print( "1-bit grayscale FPX ...\n" );
testReadWrite( 'input_bw.fpx', 'output_bw.fpx', q/quality=>95/,
   '505bb1109aaa8e798ac5a4ce3d9703ca71229f8a30cc6dbcbd15dcd410641736');

#
# 2) Test grayscale image
#
++$test;
print( "8-bit grayscale FPX ...\n" );
testReadWrite( 'input_grayscale.fpx',
   'output_grayscale.fpx', '',
   '9814609c0c4ed884caf3d0740460695ee9e789d3279442e66e4e459df7a0725a');
#
# 3) Test pseudocolor image
#
++$test;
print( "8-bit indexed-color FPX ...\n" );
testReadWrite( 'input_256.fpx',
   'output_256.fpx',
   q/quality=>54/,
   '3e63d6afc14512b058f14e4b41fdc37aac7fe7d584487f6175c7f541ce78a4d4' );
#
# 4) Test truecolor image
#
++$test;
print( "24-bit Truecolor FPX ...\n" );
testReadWrite( 'input_truecolor.fpx',
   'output_truecolor.fpx',
   q/quality=>55/,
   '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e' );

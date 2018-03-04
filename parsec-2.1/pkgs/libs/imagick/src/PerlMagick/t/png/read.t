#!/usr/bin/perl
#
# Test reading PNG images
#
# Contributed by Bob Friesenhahn <bfriesen@simple.dallas.tx.us>
#

BEGIN { $| = 1; $test=1; print "1..6\n"; }
END {print "not ok $test\n" unless $loaded;}
use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't/png' || die 'Cd failed';

#
# 1) Test Black-and-white, bit_depth=1 PNG
# 
print( "1-bit grayscale PNG ...\n" );
testRead( 'input_bw.png',
  '181b80abef002255ff7c89a3ab5711cef87230f44bbfc16175b2304e43ea12e3' );

#
# 2) Test Monochrome PNG
# 
++$test;
print( "8-bit grayscale PNG ...\n" );
testRead( 'input_mono.png',
  '46ee76cef390742f315d06262ba608c92fd717643387955d3cc3bbd688b9eba3' );

#
# 3) Test 16-bit Portable Network Graphics
# 
++$test;
print( "16-bit grayscale PNG ...\n" );
testRead( 'input_16.png',
  'd1b4ad7c53ef8d9cbfb5092bf610c3c68b18976350c3a444fcfbd47054064ecb',
  'a23448b623ced13b5cd0f78addf9600096822e14ffb01980e655490a8d11e19d' );
#
# 4) Test 256 color pseudocolor PNG
# 
++$test;
print( "8-bit indexed-color PNG ...\n" );
testRead( 'input_256.png',
  '37f97eb2ca57177f03b3c9246ce4028e9c50d9c3ab3335c4c1d920039db013f7' );

#
# 5) Test TrueColor PNG
# 
++$test;
print( "24-bit Truecolor PNG ...\n" );
testRead( 'input_truecolor.png',
  '60d3e79d0fc62a7f6ad622152f77a19c6bde0a9454a78c77de8af6be3065225e' );

#
# 6) Test Multiple-image Network Graphics
# 
++$test;
print( "MNG with 24-bit Truecolor PNGs...\n" );
testRead( 'input.mng',
  'b054bb6b19eba09f9ae531ca3e66399125d564cc056e3b5c230782f162af2a59' );


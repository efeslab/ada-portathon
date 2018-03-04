#!/usr/bin/perl
#
# Test writing TIFF images
#
# Contributed by Bob Friesenhahn <bfriesen@simple.dallas.tx.us>
#
BEGIN { $| = 1; $test=1; print "1..10\n"; }
END {print "not ok $test\n" unless $loaded;}

use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't/tiff' || die 'Cd failed';

#
# 1) Test 4-bit pseudocolor image
#
print("PseudoColor image (4 bits/sample) ...\n");
testReadWrite( 'input_16.tiff',
  'output_16.tiff',
  q//,
  'eff9f8087197689c717ee4678bc242d2973c569c20dd29bc23631f5f0d0cb058');

#
# 2) Test 8-bit pseudocolor image
#
++$test;
print("PseudoColor image (8 bits/sample) ...\n");
testReadWrite( 'input_256.tiff',
  'output_256.tiff',
  q//,
  'af0e4541c30c01c9f3527a87e5ea06912ade17dea3d3295028b87b856ec21558');

#
# 3) Test 4-bit pseudocolor + matte channel image
#
++$test;
print("PseudoColor image (4 bits/sample + matte channel) ...\n");
testReadWrite( 'input_16_matte.tiff',
  'output_16_matte.tiff',
  q//,
  'eff9f8087197689c717ee4678bc242d2973c569c20dd29bc23631f5f0d0cb058' );

#
# 4) Test 8-bit pseudocolor + matte channel image
#
++$test;
print("PseudoColor image (8 bits/sample + matte channel) ...\n");
testReadWrite( 'input_256_matte.tiff',
  'output_256_matte.tiff',
  q//,
  '01f9d29ebea733fb815dcccfa1fb769cf223d60d8bfbce47b8329d119587de15',
  '01f9d29ebea733fb815dcccfa1fb769cf223d60d8bfbce47b8329d119587de15' );

#
# 5) Test truecolor image
#
++$test;
print("TrueColor image (8 bits/sample) ...\n");
testReadWrite( 'input_truecolor.tiff',
  'output_truecolor.tiff',
  q/quality=>55/,
  '6452b611f3bf10ebe0f4809b6e27570931bc982d6c3993e28ab3d27527b182fa' );

#
# 6) Test monochrome image
#
++$test;
print("Gray image (1 bit per sample) ...\n");
testReadWrite(  'input_mono.tiff',
  'output_mono.tiff',
  q//,
  '1eb1f91d284e0b19af6610a8e3884a87178353a850287b63a0dabe8570a83e3f' );

#
# 7) Test gray 4 bit image
#
++$test;
print("Gray image (4 bits per sample) ...\n");
testReadWrite(  'input_gray_4bit.tiff',
  'output_gray_4bit.tiff',
  q//,
  'a23eabe8f0c6aa3ae4e7ef2e6a86d37befe8d8cc83ad3ede010eca25275ba478' );

#
# 8) Test gray 8 bit image
#
++$test;
print("Gray image (8 bits per sample) ...\n");
testReadWrite(  'input_gray_8bit.tiff',
  'output_gray_8bit.tiff',
  q//,
  'a3880cab9837b975d6f62116811a28578cef871c4879403a105e3d946160a078' );

#
# 9) Test gray 4 bit image (with matte channel)
#
++$test;
print("Gray image (4 bits per sample + matte channel) ...\n");
testReadWrite(  'input_gray_4bit_matte.tiff',
  'output_gray_4bit_matte.tiff',
  q//,
  'bab8bea9a756e476845511e1d02498a2aa66aeadf45126b303ff328cd13eb573',
  'bab8bea9a756e476845511e1d02498a2aa66aeadf45126b303ff328cd13eb573',
  '20fc50f858dcd84aeb29097fe8067f2f0b8059d535d81fcdf51045f28aebe905' );

#
# 10) Test gray 8 bit image (with matte channel)
#
++$test;
print("Gray image (8 bits per sample + matte channel) ...\n");
testReadWrite(  'input_gray_8bit_matte.tiff',
  'output_gray_8bit_matte.tiff',
  q//,
  '1d09012a9334266bc64255cfc8305a89afba602a93e29bec0c793851f8bb01e7',
  '1d09012a9334266bc64255cfc8305a89afba602a93e29bec0c793851f8bb01e7' );

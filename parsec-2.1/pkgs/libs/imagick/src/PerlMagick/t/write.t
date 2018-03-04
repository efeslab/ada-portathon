#!/usr/bin/perl
#
# Test writing formats supported directly by ImageMagick
#
# Currently supported tests are for formats that ImageMagick
# knows how to both read and write.
#
# Whenever a new test is added/removed, be sure to update the
# 1..n ouput.

BEGIN { $| = 1; $test=1; print "1..32\n"; }
END {print "not ok $test\n" unless $loaded;}
use Image::Magick;
$loaded=1;

require 't/subroutines.pl';

chdir 't' || die 'Cd failed';

print("AVS X image file ...\n");
testReadWrite( 'AVS:input.avs',
  'AVS:output.avs',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Microsoft Windows bitmap image file ...\n");
++$test;
testReadWrite( 'BMP:input.bmp',
  'BMP:output.bmp',
  q//,
  '723a434701e04f1b116cb504e25a097e956fb64f5d54c719084845b7ef38c1be');

print("Microsoft Windows 24-bit bitmap image file ...\n");
++$test;
testReadWrite( 'BMP:input.bmp24',
  'BMP:output.bmp24',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');


print("ZSoft IBM PC multi-page Paintbrush file ...\n");
++$test;
testReadWrite( 'DCX:input.dcx',
  'DCX:output.dcx',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Microsoft Windows 3.X DIB file ...\n");
++$test;
testReadWrite( 'DIB:input.dib',
  'DIB:output.dib',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Flexible Image Transport System ...\n");
++$test;
testReadWrite( 'FITS:input.fits',
  'FITS:output.fits',
  q//,
  'a28c3e10a294495bbe7e9d34e39640192f44010b228dee04aeaf6e6b2bfcd683' );

print("CompuServe graphics interchange format ...\n");
++$test;
testReadWrite( 'GIF:input.gif',
  'GIF:output.gif',
  q//,
  'd386accb20608fd50bd117d0d4d36fbb5c6e0add73238c76cc8ee54e51dae14a',
  '723a434701e04f1b116cb504e25a097e956fb64f5d54c719084845b7ef38c1be');

print("CompuServe graphics interchange format (1987) ...\n");
++$test;
testReadWrite( 'GIF87:input.gif87',
  'GIF87:output.gif87',
  q//,
  'd386accb20608fd50bd117d0d4d36fbb5c6e0add73238c76cc8ee54e51dae14a',
  'd386accb20608fd50bd117d0d4d36fbb5c6e0add73238c76cc8ee54e51dae14a');

print("Magick image file format ...\n");
++$test;
testReadWrite( 'MIFF:input.miff',
  'MIFF:output.miff',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("MTV Raytracing image format ...\n");
++$test;
testReadWrite( 'MTV:input.mtv',
  'MTV:output.mtv',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Portable bitmap format (black and white), ASCII format ...\n");
++$test;
testReadWrite( 'PBM:input_p1.pbm',
  'PBM:output_p1.pbm',
  q/compression=>'None'/,
  '1eb1f91d284e0b19af6610a8e3884a87178353a850287b63a0dabe8570a83e3f');

print("Portable bitmap format (black and white), binary format ...\n");
++$test;
testReadWrite( 'PBM:input_p4.pbm',
  'PBM:output_p4.pbm',
  q//,
  '1eb1f91d284e0b19af6610a8e3884a87178353a850287b63a0dabe8570a83e3f');

print("ZSoft IBM PC Paintbrush file ...\n");
++$test;
testReadWrite( 'PCX:input.pcx',
  'PCX:output.pcx',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Portable graymap format (gray scale), ASCII format ...\n");
++$test;
testReadWrite( 'PGM:input_p2.pgm',
  'PGM:output_p2.pgm',
  q/compression=>'None'/,
  'a465a1a23b2fe1c7799de93d4f9edaf742ed9a10c09cbdbfda775c02e47f82ef');

print("Apple Macintosh QuickDraw/PICT file ...\n");
++$test;
testReadWrite( 'PICT:input.pict',
  'PICT:output.pict',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Portable pixmap format (color), ASCII format ...\n");
++$test;
testReadWrite( 'PPM:input_p3.ppm',
  'PPM:output_p3.ppm',
  q/compression=>'None'/,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Portable graymap format (gray scale), binary format ...\n");
++$test;
testReadWrite( 'PGM:input_p5.pgm',
  'PGM:output_p5.pgm',
  q//,
  'a465a1a23b2fe1c7799de93d4f9edaf742ed9a10c09cbdbfda775c02e47f82ef');

print("Portable pixmap format (color), binary format ...\n");
++$test;
testReadWrite( 'PPM:input_p6.ppm',
  'PPM:output_p6.ppm',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Adobe Photoshop bitmap file ...\n");
++$test;
testReadWrite( 'PSD:input.psd',
  'PSD:output.psd',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e' );

print("Irix RGB image file ...\n");
++$test;
testReadWrite( 'SGI:input.sgi',
  'SGI:output.sgi',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("SUN 1-bit Rasterfile ...\n");
++$test;
testReadWrite( 'SUN:input.im1',
  'SUN:output.im1',
  q//,
  'a9094ccabfcccdf72a2f5ef589d9b517a555d3ea957410caa562809879c3ecb0');

print("SUN 8-bit Rasterfile ...\n");
++$test;
testReadWrite( 'SUN:input.im8',
  'SUN:output.im8',
  q//,
  '55adf0c8eddd122d0fa9129976b8c1f9e87713b4c3674fd1c73cd9087ef7e965');

print("SUN True-Color Rasterfile ...\n");
++$test;
testReadWrite( 'SUN:input.im24',
  'SUN:output.im24',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Truevision Targa image file ...\n");
++$test;
testReadWrite( 'TGA:input.tga',
  'TGA:output.tga',
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e');

print("Khoros Visualization image file ...\n");
++$test;
testReadWrite( 'VIFF:input.viff',
  'VIFF:output.viff',
  q//,
  'aa4a6154f3c314d99c257280faf9097f3863a132ec8bddbc3b68209ce2c19487');

print("WBMP (Wireless Bitmap (level 0) image) ...\n");
++$test;
testReadWrite( 'WBMP:input.wbmp',
  'WBMP:output.wbmp',
  q//,
  'd818195f73f8d5db624c8f87a706bbcb3179dbb7a7f08abbad5b12cd97de8fe6');

print("X Windows system bitmap (black and white only) ...\n");
++$test;
testReadWrite( 'XBM:input.xbm',
  'XBM:output.xbm',
  q//,
  'a9094ccabfcccdf72a2f5ef589d9b517a555d3ea957410caa562809879c3ecb0');

print("X Windows system pixmap file (color) ...\n");
++$test;
testReadWrite( 'XPM:input.xpm',
  'XPM:output.xpm',
  q//,
  '55adf0c8eddd122d0fa9129976b8c1f9e87713b4c3674fd1c73cd9087ef7e965');

print("CMYK format ...\n");
++$test;
testReadWriteSized( 'CMYK:input_70x46.cmyk',
  'CMYK:output_70x46.cmyk',
  '70x46',
  8,
  q//,
  '51bdf995d58bd7891f5700ba7214329b2f4d6fa72e94a60866c3e1153cde0e2a');

print("GRAY format ...\n");
++$test;
testReadWriteSized( 'GRAY:input_70x46.gray',
  'GRAY:output_70x46.gray',
  '70x46',
  8,
  q//,
  'a28c3e10a294495bbe7e9d34e39640192f44010b228dee04aeaf6e6b2bfcd683' );

print("RGB format ...\n");
++$test;
testReadWriteSized( 'RGB:input_70x46.rgb',
  'RGB:output_70x46.rgb',
  '70x46',
  8,
  q//,
  '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e' );


print("RGBA format ...\n");
++$test;
testReadWriteSized( 'RGBA:input_70x46.rgba',
  'RGBA:output_70x46.rgba',
  '70x46',
  8,
  q//,
  '975cdb03f0fa923936f1cecf7b8a49a917493393a0eb098828ab710295195584' );

1;

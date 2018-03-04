#!/usr/bin/perl
#
# Test image blobs.
#
BEGIN { $| = 1; $test=1, print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}
use Image::Magick;
$loaded=1;

chdir 't' || die 'Cd failed';

$image = new Image::Magick;
$image->Read( 'input.miff' );
@blob = $image->ImageToBlob();
undef $image;

$image=Image::Magick->new( magick=>'MIFF' );
$image->BlobToImage( @blob );

if ($image->Get('signature') ne 
    '5a5f94a626ee1945ab1d4d2a621aeec4982cccb94e4d68afe4c784abece91b3e')
  { print "not ok $test\n"; }
else
  { print "ok $test\n"; }

1;

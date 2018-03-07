#!/bin/sh
source ../../env_run.sh
$EXEC bin/rawcaudio < data/large.pcm > output_large.adpcm
$EXEC bin/rawdaudio < data/large.adpcm > output_large.pcm

#!/bin/sh
source ../../env_run.sh
$EXEC bin/rawcaudio < data/small.pcm > output_small.adpcm
$EXEC bin/rawdaudio < data/small.adpcm > output_small.pcm

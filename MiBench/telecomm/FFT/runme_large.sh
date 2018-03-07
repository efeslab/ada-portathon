#!/bin/sh
source ../../env_run.sh
$EXEC fft 8 32768 > output_large.txt
$EXEC fft 8 32768 -i > output_large.inv.txt

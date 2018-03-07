#!/bin/sh
$EXEC fft 4 4096 > output_small.txt
$EXEC fft 4 8192 -i > output_small.inv.txt

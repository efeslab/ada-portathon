#!/bin/sh
source ../../env_run.sh
$EXEC bin/toast -fps -c data/small.au > output_small.encode.gsm
$EXEC bin/untoast -fps -c data/small.au.run.gsm > output_small.decode.run

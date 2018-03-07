#!/bin/sh
source ../../env_run.sh
$riscvqemu bin/toast -fps -c data/large.au > output_large.encode.gsm
$EXEC bin/untoast -fps -c data/large.au.run.gsm > output_large.decode.run
#!/bin/bash

for input_file in $(ls inputs); do
    # $runqemu WATER-NSQUARED < "inputs/$input_file"
    ./WATER-NSQUARED < "inputs/$input_file"
    if [ $? != 0 ]; then
        echo "Input file '$input_file' failed"
        exit 1
    fi
done

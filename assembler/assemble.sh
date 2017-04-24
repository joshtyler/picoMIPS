#!/bin/bash
# Take an input file and assemble to machine code for picoMIPS

#Temporary file for intermediate output
tmp="$(mktemp /tmp/assemble.XXXXXX)"

./optimiser.py $1 $tmp
./assembler.py $tmp $2

rm $tmp

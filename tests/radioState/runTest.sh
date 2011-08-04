#/bin/bash

export NEDPATH="../../base;../../modules;../../../inet/src"

./radioState > out.tmp

diff -I '^Assigned runID=' -I '^Loading NED files from' -w exp-output out.tmp

rm -f out.tmp

#/bin/bash

# old testing setup
# Test configurations with TestBaseDecider as Decider

export NEDPATH="../../base;../../modules;../../../inet/src"

./decider > out.tmp 2>&1

diff -I '^Assigned runID=' -I '^Loading NED files from' -w exp-output out.tmp

rm -f out.tmp



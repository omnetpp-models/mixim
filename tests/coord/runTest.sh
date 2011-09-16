#/bin/bash

export PATH="$PATH:../../src:../../../inet/src:../../../omnetpp/bin"

../tests > out.tmp

diff -I '^Assigned runID=' -I '^Loading NED files from'  -w exp-output out.tmp

rm -f out.tmp

#/bin/bash

export PATH="$PATH:../../src:../../../inet/src:../../../omnetpp/bin"

../tests -c Test1 > exp-output
../tests -c Test2 >> exp-output
../tests -c Test6 >> exp-output
../tests -c Test7 >> exp-output

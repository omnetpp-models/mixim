#/bin/bash

export PATH="$PATH:../../src:../../../inet/src:../../../omnetpp/bin"

../tests -c Test1 > exp-output
../tests -c Test2 >> exp-output
../tests -c Test3 >> exp-output
../tests -c Test4 >> exp-output
../tests -c Test5 >> exp-output

#!/bin/bash

lPATH='.'
LIBSREF=( )
lINETPath='../../../inet/src'
for lP in '../../src' \
          '../../src/base' \
          '../../src/modules' \
          '../testUtils' \
          "$lINETPath"; do
    for pr in 'mixim' 'inet'; do
        if [ -d "$lP" ] && [ -f "${lP}/lib${pr}$(basename $lP).so" -o -f "${lP}/lib${pr}$(basename $lP).dll" ]; then
            lPATH="${lP}:$lPATH"
            LIBSREF=( '-l' "${lP}/${pr}$(basename $lP)" "${LIBSREF[@]}" )
        elif [ -d "$lP" ] && [ -f "${lP}/lib${pr}.so" -o -f "${lP}/lib${pr}.dll" ]; then
            lPATH="${lP}:$lPATH"
            LIBSREF=( '-l' "${lP}/${pr}" "${LIBSREF[@]}" )
        fi
    done
done
PATH="${PATH}:${lPATH}" #needed for windows
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${lPATH}"
NEDPATH="../../src/base:../../src/modules:.."
if [ -n "`grep KINET_PROJ ../Makefile`" ]; then
  NEDPATH="${NEDPATH}:$lINETPath"
else
  NEDPATH="${NEDPATH}:../../src/inet_stub"
fi
export PATH
export NEDPATH
export LD_LIBRARY_PATH

lCombined='miximtests'
lSingle='coord'
lIsComb=0
if [ ! -e ${lSingle} -a ! -e ${lSingle}.exe ]; then
    if [ -e ../${lCombined}.exe ]; then
        ln -s ../${lCombined}.exe ${lSingle}.exe
        lIsComb=1
    elif [ -e ../${lCombined} ]; then
        ln -s ../${lCombined}     ${lSingle}
        lIsComb=1
    fi
fi

./${lSingle} "${LIBSREF[@]}">  out.tmp 2>  err.tmp

[ x$lIsComb = x1 ] && rm -f ${lSingle} ${lSingle}.exe >/dev/null 2>&1
diff -I '^Assigned runID=' \
     -I '^Loading NED files from' \
     -I '^OMNeT++ Discrete Event Simulation' \
     -I '^Version: ' \
     -I '^     Speed:' \
     -I '^** Event #' \
     -w exp-output out.tmp >diff.log 2>/dev/null

if [ -s diff.log ]; then
    echo "FAILED counted $(( 1 + $(grep -c -e '^---$' diff.log) )) differences where #<=$(grep -c -e '^<' diff.log) and #>=$(grep -c -e '^>' diff.log); see $(basename $(cd $(dirname $0);pwd) )/diff.log"
    [ "$1" = "update-exp-output" ] && \
        cat out.tmp >exp-output
    exit 1
else
    echo "PASSED $(basename $(cd $(dirname $0);pwd) )"
    rm -f out.tmp diff.log err.tmp
fi
exit 0

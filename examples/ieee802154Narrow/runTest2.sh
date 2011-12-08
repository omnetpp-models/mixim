#!/bin/bash

lPATH='.'
LIBSREF=( )
lINETPath='../../../inet/src'
for lP in '../../src' \
          '../../src/base' \
          '../../src/modules' \
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
NEDPATH="../../src:.."
[ -d "$lINETPath" ] && NEDPATH="${NEDPATH}:$lINETPath"
export PATH
export NEDPATH
export LD_LIBRARY_PATH

lCombined='miximexamples'
lSingle='ieee802154Narrow'
if [ ! -e ${lSingle} -a ! -e ${lSingle}.exe ]; then
    if [ -e ../${lCombined}.exe ]; then
        ln -s ../${lCombined}.exe ${lSingle}.exe
    elif [ -e ../${lCombined} ]; then
        ln -s ../${lCombined}     ${lSingle}
    fi
fi

rm -f results/Test2*
echo 'Run all Test2-A...'
opp_runall $1 ./${lSingle} -c Test2-A -u Cmdenv -r 0..38 "${LIBSREF[@]}"  >  out2.tmp 2>  err.tmp
echo 'Run all Test2-B...'
opp_runall $1 ./${lSingle} -c Test2-B -u Cmdenv -r 0..38 "${LIBSREF[@]}" >>  out2.tmp 2>  err.tmp
echo 'Run all Test2-B...'
opp_runall $1 ./${lSingle} -c Test2-C -u Cmdenv -r 0..38 "${LIBSREF[@]}" >>  out2.tmp 2>  err.tmp

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

rm -f results/Test1*
echo 'Run all Test1-A...'
opp_runall ./${lSingle} -c Test1-A -u Cmdenv -r 0..19 "${LIBSREF[@]}" $1 >  out1.tmp 2>  err.tmp
echo 'Run all Test1-B...'
opp_runall ./${lSingle} -c Test1-B -u Cmdenv -r 0..19 "${LIBSREF[@]}" $1 >>  out1.tmp 2>  err.tmp
echo 'Run all Test1-C...'
opp_runall ./${lSingle} -c Test1-C -u Cmdenv -r 0..19 "${LIBSREF[@]}" $1 >>  out1.tmp 2>  err.tmp
echo 'Run all Test1-D...'
opp_runall ./${lSingle} -c Test1-D -u Cmdenv -r 0..19 "${LIBSREF[@]}" $1 >>  out1.tmp 2>  err.tmp
echo 'Run all Test1-E...'
opp_runall ./${lSingle} -c Test1-E -u Cmdenv -r 0..19 "${LIBSREF[@]}" $1 >>  out1.tmp 2>  err.tmp

#!/bin/bash

lPATH='.'
LIBSREF=( )
lINETPath='../../../../inet/src'
for lP in '../../../src' \
          '../../../src/base' \
          '../../../src/modules' \
          '../../testUtils' \
          '../utils' \
          "$lINETPath"; do
    for pr in 'mixim' 'inet' 'powerTestUtils'; do
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
NEDPATH="../../../src/base:../../../src/modules:../.."
if [ -n "`grep KINET_PROJ ../../Makefile`" ]; then
  NEDPATH="${NEDPATH}:$lINETPath"
else
  NEDPATH="${NEDPATH}:../../../src/inet_stub"
fi
export PATH
export NEDPATH
export LD_LIBRARY_PATH

lCombined='miximtests'
lSingle='deviceTest'
lIsComb=0
if [ ! -e "${lSingle}" -a ! -e "${lSingle}.exe" ]; then
    if [ -e "../../${lCombined}.exe" ]; then
        ln -s "../../${lCombined}.exe" "${lSingle}.exe"
        lIsComb=1
    elif [ -e "../../${lCombined}" ]; then
        ln -s "../../${lCombined}"     "${lSingle}"
        lIsComb=1
    fi
fi
          
rm *.vec *.sca 2>/dev/null
for i in One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen
do
 ./${lSingle} -c $i "${LIBSREF[@]}"
done
[ x$lIsComb = x1 ] && rm -f ${lSingle} ${lSingle}.exe >/dev/null 2>&1

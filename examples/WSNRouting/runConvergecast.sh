#!/bin/bash

lPATH='.'
LIBSREF=( )
lINETPath='../../../inet'
lMiXiMPath='../..'
for lP in "${lMiXiMPath}/src" \
          "${lMiXiMPath}/src/base" \
          "${lMiXiMPath}/src/modules" \
          "${lINETPath}/src"; do
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
NEDPATH="${lMiXiMPath}/src/base:${lMiXiMPath}/src/modules:..:."
if [ -d "${lINETPath}/src" ]; then
  NEDPATH="${NEDPATH}:${lINETPath}/src"
else
  NEDPATH="${NEDPATH}:${lMiXiMPath}/src/inet_stub"
fi
export PATH
export NEDPATH
export LD_LIBRARY_PATH

lCombined='miximexamples'
lSingle='WSNRouting'
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

rm -f results/convergecast-*
echo 'Run all ConverCast...'
./${lSingle} -u Cmdenv -c convergecast "${LIBSREF[@]}" >  outcon.tmp 2>errcon.tmp

[ x$lIsComb = x1 ] && rm -f ${lSingle} ${lSingle}.exe >/dev/null 2>&1
[ ! -s errcon.tmp ] && \rm -f errcon.tmp >/dev/null 2>&1

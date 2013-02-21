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
lSingle='ieee802154Narrow'
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

rm -f results/Test2*
echo 'Run all Test2-A...'
opp_runall $1 ./${lSingle} -c Test2-A -u Cmdenv -r 0..38 "${LIBSREF[@]}"  >  out2.tmp 2>  err2.tmp
echo 'Run all Test2-B...'
opp_runall $1 ./${lSingle} -c Test2-B -u Cmdenv -r 0..38 "${LIBSREF[@]}" >>  out2.tmp 2>> err2.tmp
echo 'Run all Test2-C...'
opp_runall $1 ./${lSingle} -c Test2-C -u Cmdenv -r 0..38 "${LIBSREF[@]}" >>  out2.tmp 2>> err2.tmp

[ x$lIsComb = x1 ] && rm -f ${lSingle} ${lSingle}.exe >/dev/null 2>&1
[ ! -s err2.tmp ] && \rm -f err2.tmp >/dev/null 2>&1

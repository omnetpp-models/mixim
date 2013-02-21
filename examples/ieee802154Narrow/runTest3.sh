#!/bin/sh

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

rm -f results/Test3*
echo 'Run all Test3...'
opp_runall $1 ./${lSingle} -c Test3 -u Cmdenv -r 0..6 "${LIBSREF[@]}" >  out3.tmp 2>  err3.tmp &
./${lSingle} -c Test3 -u Cmdenv -r 7 "${LIBSREF[@]}" >out3-7.tmp 2>err3-7.tmp

wait

[ x$lIsComb = x1 ] && rm -f ${lSingle} ${lSingle}.exe >/dev/null 2>&1
[ ! -s err3.tmp ]   && \rm -f err3.tmp >/dev/null 2>&1
[ ! -s err3-7.tmp ] && \rm -f err3-7.tmp >/dev/null 2>&1

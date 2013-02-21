#!/bin/bash

iFailedSca=0
iFailedVec=0
iFileCnt=0

for f in *.vec 
do
 if [ -f "$f" ]; then
  diff -I '^version' -I '^run' -I '^attr' -I '^vector' -w "$f" "valid/$f" >diff.log 2>/dev/null
  if [ -s diff.log ]; then
    iFileCnt=$(( $iFileCnt + 1 ))
    lres="diff-$(echo $f |cut -d. -f1).log"
    echo "  FAILED $f counted $(( 1 + $(grep -c -e '^---$' diff.log) )) differences where #<=$(grep -c -e '^<' diff.log) and #>=$(grep -c -e '^>' diff.log); see $(basename $(pwd) )/$lres"
    mv -f 'diff.log' "$lres" >/dev/null 2>&1
    iFailedVec=$(( $iFailedVec + 1 ))
  else
    echo "  PASSED valid/$f"
    rm -f "$f" "$(echo $f |cut -d. -f1).vci" out.tmp diff.log err.tmp
  fi
 fi
done
if [ -d results ]; then
 cd results >/dev/null 2>&1
 for f in *.sca
 do
  if [ -f "$f" ]; then
   iFileCnt=$(( $iFileCnt + 1 ))
   diff -I '^version' -I '^run' -I '^attr' -I '^vector' -w "$f" "../valid/$f" >diff.log 2>/dev/null
   if [ -s diff.log ]; then
    lres="diff-$(echo $f |cut -d. -f1).log"
    echo "  FAILED $f counted $(( 1 + $(grep -c -e '^---$' diff.log) )) differences where #<=$(grep -c -e '^<' diff.log) and #>=$(grep -c -e '^>' diff.log); see $(basename $(cd ..; pwd) )/results/$lres"
    mv -f 'diff.log' "$lres" >/dev/null 2>&1
    iFailedSca=$(( $iFailedSca + 1 ))
   else
    echo "  PASSED valid/$f"
    rm -f "$f" out.tmp diff.log err.tmp
   fi
  fi
 done
 cd ..
 [ $iFailedSca = 0 ] && rm -rf results >/dev/null 2>&1
fi
if [ x$iFileCnt != x0 ]; then
  iFileCnt=0
else
  iFileCnt=1
fi
exit $(( $iFailedVec + $iFailedSca + $iFileCnt ))

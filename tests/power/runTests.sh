#!/bin/bash

BasePath="$( cd $(dirname $0); pwd )"

echo ' ========== Running power tests =============='
e='--------------------------------'
for f in deviceTest deviceTestMulti deviceTestAccts deviceTestAll #Nic80211Test
do
 if [ -d "${BasePath}/$f" -a -f "${BasePath}/$f/runTests.sh" ]; then
  echo " -------------$f${e:${#f}}"
  ( cd "${BasePath}/$f" && \
    ./runTests.sh >run.log 2>&1 )
 fi
done

iErrs=0
echo ' ======== Checking results of tests =========='
for f in deviceTest deviceTestMulti deviceTestAccts deviceTestAll #Nic80211Test
do
 if [ -d "${BasePath}/$f" -a -f "${BasePath}/checkResults.sh" ]; then
  echo " -------------$f${e:${#f}}"
  ( cd "${BasePath}/$f" && \
    ../checkResults.sh )
  st=$?
  [ x$st = x0 ] || iErrs=$(( $iErrs + 1 ))
 fi
done

exit $iErrs

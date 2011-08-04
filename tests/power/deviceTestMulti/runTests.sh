export NEDPATH="../../../base;../../../modules;../../../../inet/src"
rm *.vec results/*.sca
for i in One Two Three Four
do
 ./deviceTestMulti -c $i -u Cmdenv
done


export NEDPATH="../../../base;../../../modules;../../../../inet/src"
rm *.vec results/*.sca
for i in One 
do
 ./deviceTestAll -c $i
done


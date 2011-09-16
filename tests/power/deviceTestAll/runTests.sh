export PATH="$PATH:../../../src:../../../../inet/src:../../../../omnetpp/bin"

rm *.vec results/*.sca
for i in One 
do
 ../../tests -c $i
done

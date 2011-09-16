export PATH="$PATH:../../../src:../../../../inet/src:../../../../omnetpp/bin"

rm *.vec results/*.sca
for i in One Two Three Four
do
 ../../tests -c $i
done

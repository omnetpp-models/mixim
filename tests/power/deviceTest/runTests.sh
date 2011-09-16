export PATH="$PATH:../../../src:../../../../inet/src:../../../../omnetpp/bin"

rm *.vec *.sca
for i in One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen
do
 ../../tests -c $i
done

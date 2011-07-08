// A LMAC packet format definition
// 
// @author Anna Foerster


cplusplus {{
#include <MACAddress.h>
#include <MacPkt_m.h>
}}


class MACAddress extends void;
class MacPkt;


message LMacPkt extends MacPkt
{
    int mySlot; // the node's current slot number
    MACAddress occupiedSlots[]; // currently known occupied slots
}

// A LMAC packet format definition
// 
// @author Anna Foerster


cplusplus {{
#include "MiXiMMacPkt.h"
}}

class MacPkt;
class LAddress::L2Type extends void;

message LMacPkt extends MacPkt
{
    int              mySlot; // the node's current slot number
    LAddress::L2Type occupiedSlots[]; // currently known occupied slots
}

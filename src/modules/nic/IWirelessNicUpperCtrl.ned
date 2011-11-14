package org.mixim.modules.nic;

moduleinterface IWirelessNicUpperCtrl extends inet.linklayer.IWirelessNic
{
    parameters:
        @display("i=block/ifcard");

    gates:
        input upperLayerIn; // to upper layers
        output upperLayerOut; // from upper layers
        input radioIn @labels(AirFrame); // to receive AirFrames
        //# following gates are not defined in INET
        
        input  upperControlIn;            // control gate for incoming control messages from network layer
        output upperControlOut;           // control gate to send control messages to network layer
}

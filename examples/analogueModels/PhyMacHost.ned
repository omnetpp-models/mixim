package org.mixim.examples.analogueModels;

import inet.mobility.IMobility;
import org.mixim.base.modules.BaseUtility;


module PhyMacHost
{
    parameters:
        double numHosts; // total number of hosts in the network
        string mobilityType = default("StationaryMobility"); // how the node moves around. see: inet.mobility
        @display("bgb=180,200,white,,;bgp=10,10");
    gates:
        input radioIn;

    submodules:
        utility: BaseUtility {
            parameters:
                @display("p=130,60;i=block/blackboard");
        }
        mobility: <mobilityType> like IMobility {
            parameters:
                @display("p=130,130;i=block/cogwheel");
        }
        nic: PhyMacNic {
            parameters:
                @display("b=32,30;p=60,166;i=block/ifcard");
        }
    connections:

        radioIn --> nic.radioIn;

}


package org.mixim.tests.basePhyLayer;

import inet.mobility.models.StationaryMobility;


module TestHost
{
    parameters:
        double numHosts; // total number of hosts in the network
        @display("bgb=180,200,white,,;bgp=10,10");
        @node();
    gates:
        input radioIn;

    submodules:
        mobility: StationaryMobility {
            parameters:
                @display("p=130,130;i=cogwheel2");
        }
        nic: TestNic {
            parameters:
                @display("b=32,30;p=60,166;i=iface");
        }
    connections:

        radioIn --> nic.radioIn;

}


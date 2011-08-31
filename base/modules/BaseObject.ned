package org.mixim.base.modules;

import inet.mobility.IMobility;


module BaseObject
{
    parameters:
        string mobilityType = default("StationaryMobility"); // how the node moves around. see: inet.mobility
        @display("bgb=180,200,white,,;bgp=10,10");
    submodules:
        mobility: <mobilityType> like IMobility {
            parameters:
                @display("p=130,172;i=cogwheel2");

        }
}


package org.mixim.examples.inet.adhoc;


import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
import inet.nodes.inet.WirelessHost;
import org.mixim.base.modules.BaseNetwork;


//Network for testing hosts containing an INET network stack and a MiXiM 802.11 NIC.
network Adhoc extends BaseNetwork
{
    parameters:
        int numHosts; // total number of hosts in the network  
        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=10,50");

    submodules:
        host[numHosts]: WirelessHost {
            parameters:
                @display("r=,,#707070");
        }
        configurator: FlatNetworkConfigurator {
            parameters:
                @display("p=108,0;i=block/cogwheel;is=s");
        }
}

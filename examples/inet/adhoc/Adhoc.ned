package org.mixim.examples.inet.adhoc;


import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
import inet.nodes.inet.WirelessHost;
import org.mixim.base.connectionManager.ConnectionManager;
import org.mixim.base.modules.BaseWorldUtility;


//Network for testing hosts containing an INET network stack and a MiXiM 802.11 NIC.
network Adhoc
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        double numHosts; // total number of hosts in the network  
        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=10,50");
    submodules:
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=171,25");

        }
        connectionManager: ConnectionManager {
            parameters:
                @display("p=66,25");
        }
        host[numHosts]: WirelessHost {
            parameters:
                @display("r=,,#707070");
                wlan[*].typename = "org.mixim.modules.nic.Nic80211";
        }
        configurator: FlatNetworkConfigurator {
            parameters:
                @display("p=249,25;i=block/cogwheel");
        }
}

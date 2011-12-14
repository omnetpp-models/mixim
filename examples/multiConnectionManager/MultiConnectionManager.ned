package org.mixim.examples.multiConnectionManager;

import org.mixim.base.connectionManager.ConnectionManager;
import org.mixim.base.modules.BaseNetwork;

//
//This example shows how to use multiple ConnectionManagers in your simulation. 
//
//The network contains two independent ConnectionManagers: "ISMChannel" and "GSMChannel".
//There also is its own list of hosts for each channel "ISMNode" and "GSMNode".
//Both types of hosts use BurstApplLayer <-> BaseNetwLayer <-> CSMAMacLayer <-> 
//PhyLayer as network stack. Whereas the PhyLayer uses "SimplePathlossModel" 
//as AnalogueModel and "SNRThresholdDecider" as Decider.
//
//The channel a host uses is defined in its NICs "connectionManagerName" parameter.
//
//Since the settings for the SimplePathlossModel differ for the GSM- and ISM-Nodes
//there are two seperate <config>.xml for them (GSMmodels.xml and ISMmodels.xml).
//
//The omnetpp.ini contains the following run configurations:
//
//- Config1 - Three hosts which use the same ConnectionManager. No propagation delay.
//- Config2 - Same as Config1 but with propagation delay.
//- Config3 - Two hosts using the GSMChannel ConnectionManager and two host using
//		  	  the ISMChannel ConnectionManager. No propagation delay.
//- Config4 - Same as Config3 but with propagation delay.
//- General - Same as Config3
//
network MultiConnectionManager extends BaseNetwork
{
    parameters:
        int numGSMHosts; // total number of weak hosts in the network
        int numISMHosts; // total number of strong hosts in the network

        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=10,50");
    submodules:
        ISMChannel: ConnectionManager {
            parameters:
                @display("p=121,0;i=abstract/multicast;is=s");
        }
        GSMNode[numGSMHosts]: PhyMacHost {
            parameters:
                numHosts = numGSMHosts;
                @display("p=70,91;b=42,42,rect,red;i=device/palm");

        }
        ISMNode[numISMHosts]: PhyMacHost {
            parameters:
                numHosts = numISMHosts;
                @display("p=202,91;b=42,42,rect,green;i=device/wifilaptop");

        }
    connections allowunconnected:
                         // all connections and gates are to be generated dynamically

}


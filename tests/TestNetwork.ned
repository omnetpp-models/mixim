package org.mixim.tests;

import org.mixim.base.modules.BaseNetwork;
import org.mixim.base.modules.BaseWorldUtility;

// Basis definition of test networks.
network BaseTestNetwork
{
}

// Basis definition of test networks which are common to MiXiM 
// network definition. 
network ExtTestNetwork extends BaseNetwork
{
    parameters:
        int numHosts; // total number of hosts in the network
}

// Basis definition of test networks which are not common to MiXiM 
// network definition, because of missing connectionManager.
network WorldOnlyTestNetwork extends BaseTestNetwork
{
    parameters:
        // parametes for the framework
        double playgroundSizeX @unit(m);
        double playgroundSizeY @unit(m);
        double playgroundSizeZ @unit(m);
        int numHosts @prompt("Number of hosts:") = default(2);
        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=0,0");

    submodules:
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;

                @display("p=278,0;is=s");
        }
    connections allowunconnected:
    // all connections and gates are to be generated dynamically
}

// Basis definition for all test nodes.
module TestNode
{
}

// Basis definition for all test objects.
simple TestObject
{
}

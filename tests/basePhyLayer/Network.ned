package org.mixim.tests.basePhyLayer;

import org.mixim.tests.ExtTestNetwork;

// Test network for PHY implementation tests.
network tbpSim extends ExtTestNetwork
{
    parameters:
        int run; // total number of hosts in the network
        bool showPassed;
    submodules:
        testManager: BasePhyTests {
            @display("p=54,97");
        }
        node[numHosts]: TestHost {
            parameters:
                numHosts = numHosts;
                @display("p=149,96;i=laptop");

        }
}


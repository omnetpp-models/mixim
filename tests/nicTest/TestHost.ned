package org.mixim.tests.nicTest;

import org.mixim.modules.node.WirelessNodeNetwl;

module TestHost extends WirelessNodeNetwl
{
    parameters:
        networkType = "org.mixim.tests.nicTest.TestApp";
        arpType = "ArpHost";
        @display("bgb=180,200,white,,;bgp=10,10");

    connections allowunconnected:
}

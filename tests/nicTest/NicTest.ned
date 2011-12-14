//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package org.mixim.tests.nicTest;

import org.mixim.tests.ExtTestNetwork;

// Test network for NIC implementation tests.
network NicTest extends ExtTestNetwork
{
    parameters:
        int run; // total number of hosts in the network
        bool showPassed;
        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=10,10");

    submodules:
        testManager: NicTests {
            @display("p=150,50");
        }
        node[numHosts]: TestHost {
            parameters:
                @display("p=50,50;i=laptop");

        }
}

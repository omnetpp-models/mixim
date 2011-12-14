//# Energy Framework for Omnet++, version 0.9
//#
//# Author:  Laura Marie Feeney 
//# 
//# Copyright 2009 Swedish Institute of Computer Science.  
//# 
//# This software is provided `as is' and without any express or implied
//# warranties, including, but not limited to, the implied warranties of
//# merchantability and fitness for a particular purpose.
//#
//######################################################################
// empty host to test energy framework.  see README.txt for details.
package org.mixim.tests.power;

import org.mixim.modules.power.battery.SimpleBattery;
import org.mixim.modules.power.battery.BatteryStats;
import org.mixim.tests.TestNode;

module PowerTestNode extends TestNode
{
    parameters:
        @display("bgb=175,158,$color;bgp=10,10");
    submodules:
        battery: SimpleBattery {
            parameters:
                numDevices = default(1);
                @display("p=45,40;b=30,25");
        }
        batteryStats: BatteryStats {
            @display("p=131,40");
        }
}

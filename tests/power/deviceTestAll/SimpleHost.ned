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
package org.mixim.tests.power.deviceTestAll;

import org.mixim.tests.power.utils.DeviceDuty;
import org.mixim.tests.power.utils.DeviceDutySimple;
import org.mixim.tests.power.PowerTestNode;

// Empty host with three devices for simple power test. 
module PowerTrippleTestHost extends PowerTestNode
{
    parameters:
        @display("bgb=250,153,$color;bgp=10,10");
        battery.numDevices = 3;

    submodules:
        firstDevice: DeviceDutySimple {
            parameters:
                @display("p=45,98;b=30,25");
        }
        secondDevice: DeviceDuty {
            parameters:
                @display("p=131,98;b=30,25");
        }
        thirdDevice: DeviceDutySimple {
            parameters:
                @display("p=210,98;b=30,25");
        }
}

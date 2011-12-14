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
package org.mixim.tests.power.deviceTestMulti;

import org.mixim.tests.power.utils.DeviceDutySimple;
import org.mixim.tests.power.PowerTestNode;

// Empty host with two devices for simple power test. 
module PowerDuoTestHost extends PowerTestNode
{
    parameters:
        @display("bgb=190,153,$color;bgp=10,10");
        battery.numDevices = 2;

    submodules:
        firstDevice: DeviceDutySimple {
            parameters:
                @display("p=131,112;b=30,25");
        }
        secondDevice: DeviceDutySimple {
            parameters:
                @display("p=45,112;b=30,25");
        }
}

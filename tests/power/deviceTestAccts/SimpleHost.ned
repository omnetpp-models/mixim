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
package org.mixim.tests.power.deviceTestAccts;

import org.mixim.tests.power.utils.DeviceDuty;
import org.mixim.tests.power.PowerTestNode;

// Empty host for simple power test. 
module PowerTestHost extends PowerTestNode
{
    parameters:
        @display("bgb=177,156,$color;bgp=10,10");
    submodules:
        device: DeviceDuty {
            parameters:
                @display("p=45,107;b=30,25");
        }
}

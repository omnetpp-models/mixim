//#
//# Energy Framework for Omnet++, version 0.9
//#
//# Author:  Laura Marie Feeney 
//# 
//# Copyright 2009 Swedish Institute of Computer Science.  
//# 
//# This software is provided `as is' and without any express or implied
//# warranties, including, but not limited to, the implied warranties of
//# merchantability and fitness for a particular purpose.
//######################################################################
// Tests the Nic80211Battery, the Energy Framework's battery aware
// 802.11 module
package org.mixim.tests.power.Nic80211Test;

import org.mixim.modules.node.WirelessNodeBattery;

module Nic80211TestHost extends WirelessNodeBattery
{
    parameters:
		nicType = "org.mixim.modules.nic.Nic80211Battery";
}

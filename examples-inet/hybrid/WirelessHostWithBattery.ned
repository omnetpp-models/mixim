package org.mixim.examples.inet.hybrid;

import inet.nodes.inet.WirelessHost;
import org.mixim.modules.power.battery.BatteryStats;
import org.mixim.modules.power.battery.SimpleBattery;


// This host is an example on how a host with INET network stack
// can be equipped with mobility- and wireless-modules from MiXiM. 
//
// It contains an INET network stack and a MiXiM 802.15.4 NIC (TI_CC2420)
// as well as a battery module from MiXiM which is used by the NIC.
//
// This host's NIC is able to operate in a multi-ConnectionManager
// network, i.e. more than one physical network in parallel (non-interfering).
// TODO: factor out battery into INET
module WirelessHostWithBattery extends WirelessHost
{
    submodules:
        batteryStats: BatteryStats {
            @display("p=60,106;i=block/circle");
        }
        battery: SimpleBattery {
            @display("p=60,176;i=block/control");
        }
}


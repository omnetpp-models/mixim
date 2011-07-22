package org.mixim.examples.inet.hybrid;

import inet.nodes.inet.Router;
import org.mixim.modules.power.battery.BatteryStats;
import org.mixim.modules.power.battery.SimpleBattery;


// Router equipped with all types of NICs existent in the network's hosts,
// able to route packages between all of the hosts.
//
// It consists of an INET network-layer, MiXiM NICs
// TODO: factor out battery
module RouterWithBattery extends Router
{
    parameters:
        @display("i=device/wifilaptop;bgb=392,418");
    submodules:
        batteryStats: BatteryStats {
            @display("p=242,49;i=block/circle");
        }
        battery: SimpleBattery {
            @display("p=314,49;i=block/control");
        }
}

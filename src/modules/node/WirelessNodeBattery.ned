package org.mixim.modules.node;

import org.mixim.modules.power.battery.BatteryStats;
import org.mixim.modules.power.battery.SimpleBattery;

//
// Standard host module for a wireless MiXiM host with configurable NIC, and OSI 
// layers, and mobility module. Additional it includes a battery module plus statistics.
//
module WirelessNodeBattery extends WirelessNode
{
    parameters:
        @display("bgb=210,450,white;i=device/palm;b=40,40,rect");
    submodules:
        batteryStats: BatteryStats {
            @display("p=140,240;i=block/table,#FF8040");
        }
        battery: SimpleBattery {
            @display("p=140,170;i=block/plug,#FF8000");
        }
}

module WirelessNodeBatteryNetwl extends WirelessNodeBattery
{
    parameters:
        transportType = default("");    //type of the transport layer
        sessionType = default("");      //type of the session layer
        presentationType = default(""); //type of the presentation layer
        applicationType = default("");  //type of the application layer

	connections allowunconnected:
}

module WirelessNodeBatteryPlusTran extends WirelessNodeBattery
{
    parameters:
        sessionType = default("");      //type of the session layer
        presentationType = default(""); //type of the presentation layer
        applicationType = default("");  //type of the application layer
}

package mixnet.examples.hybrid;

import inet.base.NotificationBoard;
import inet.linklayer.ethernet.EthernetInterface;
import inet.linklayer.ppp.PPPInterface;
import inet.mobility.models.StationaryMobility;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.ipv4.RoutingTable;
import inet.nodes.inet.NetworkLayer;
import org.mixim.modules.nic.Nic80211;
import org.mixim.modules.nic.Nic802154_TI_CC2420;
import org.mixim.modules.power.battery.BatteryStats;
import org.mixim.modules.power.battery.SimpleBattery;


// Router equipped with all types of NICs existent in the network's hosts,
// able to route packages between all of the hosts.
//
// It consists of an INET network-layer, MiXiM NICs
module HybridRouter
{
    parameters:
        @node();
        @labels(node,ethernet-node,wireless-node);
        @display("i=device/wifilaptop;bgb=392,418");

        string routingFile = default("");
    gates:
        inout pppg[] @labels(PPPFrame-conn);
        inout ethg[] @labels(EtherFrame-conn);
        input wlanRadioIn @directIn;
        input lrwpanRadioIn @directIn;
    submodules:
        batteryStats: BatteryStats {
            @display("p=242,49;i=block/circle");
        }
        battery: SimpleBattery {
            @display("p=314,49;i=block/control");
        }
        mobility: StationaryMobility {
            parameters:
                @display("p=155,119");
        }

        notificationBoard: NotificationBoard {
            parameters:
                @display("p=60,49");
        }
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=60,131");
        }
        routingTable: RoutingTable {
            parameters:
                IPForward = true;
                routerId = "auto";
                routingFile = routingFile;
                @display("p=60,200");
        }

        networkLayer: NetworkLayer {
            parameters:
                proxyARP = true;
                @display("p=265,218;q=queue");
            gates:
                ifIn[(sizeof(pppg)+sizeof(ethg))+2];
                ifOut[(sizeof(pppg)+sizeof(ethg))+2];
        }
        ppp[sizeof(pppg)]: PPPInterface {
            parameters:
                @display("p=343,370,row,90;q=txQueue");
        }
        eth[sizeof(ethg)]: EthernetInterface {
            parameters:
                @display("p=265,345,row,90;q=txQueue");
        }

        wlan: Nic80211 {
            parameters:
                @display("p=180,370;q=queue");
        }

        lrwpan: Nic802154_TI_CC2420 {
            parameters:
                @display("p=92,370;i=block/ifcard");
        }

    connections allowunconnected:


        // connections to network outside
        for i=0..sizeof(pppg)-1 {
            pppg[i] <--> ppp[i].phys;
            ppp[i].netwOut --> networkLayer.ifIn[i];
            ppp[i].netwIn <-- networkLayer.ifOut[i];
        }

        for i=0..sizeof(ethg)-1 {
            ethg[i] <--> eth[i].phys;
            eth[i].netwOut --> networkLayer.ifIn[sizeof(pppg)+i];
            eth[i].netwIn <-- networkLayer.ifOut[sizeof(pppg)+i];
        }

        wlanRadioIn --> wlan.radioIn;

        wlan.upperLayerOut --> { @display("ls=black;m=m,25,50,25,0"); } --> networkLayer.ifIn[(sizeof(pppg)+sizeof(ethg))];
        wlan.upperLayerIn <-- { @display("ls=black;m=m,15,50,15,0"); } <-- networkLayer.ifOut[(sizeof(pppg)+sizeof(ethg))];
        // wlan.upperControlOut --> { @display("ls=red;m=m,75,50,75,0"); } --> wlanBridge.lowerControlIn;
        // wlan.upperControlIn <-- { @display("ls=red;m=m,85,0,85,0"); } <-- wlanBridge.lowerControlOut;


        lrwpanRadioIn --> lrwpan.radioIn;

        lrwpan.upperLayerOut --> { @display("ls=black;m=m,25,50,25,0"); } --> networkLayer.ifIn[(sizeof(pppg)+sizeof(ethg))+1];
        lrwpan.upperLayerIn <-- { @display("ls=black;m=m,15,50,15,0"); } <-- networkLayer.ifOut[(sizeof(pppg)+sizeof(ethg))+1];
        // lrwpan.upperControlOut --> { @display("ls=red;m=m,75,50,75,0"); } --> lrwpanBridge.lowerControlIn;
        // lrwpan.upperControlIn <-- { @display("ls=red;m=m,85,0,85,0"); } <-- lrwpanBridge.lowerControlOut;
}


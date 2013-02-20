package org.mixim.examples.inet.hybrid;

import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.WirelessHost;
import inet.world.radio.ChannelControl;
import org.mixim.base.connectionManager.ConnectionManager;
import org.mixim.base.modules.BaseWorldUtility;


//Network for testing a hybrid host (hybridRouter) containing different wired
//(from INET) and wireless (from MiXiM and INET) NICs.
//
//This network contains several hosts, each equipped with a different type of
//NIC, in particular ethernet, 802.11 (MiXiM abd INET) and 802.15.4 (TI_CC2420).
//
//Further the network contains the hybridRouter which is equipped with
//all of these types of NICs. Thus the hybridRouter is capable of establishing a
//connection to every host in the network as well as route packages between
//hosts.
//
//All hosts which are not the router are equipped with a PING-application. The
//several configurations demonstrate the sending of PINGs between the different
//hosts, routed by the hybridRouter.
//
//Note: NICs connected by different ConnectionManagers (here: 802.11 and
//      802.15.4) cannot interfere with each other yet. INET is using the
//      ChannelController for this purpose.
network Hybrid
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=469,300,white;bgp=10,50");
    submodules:
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=37,25");
        }
        channel80211: ConnectionManager {
            parameters:
                @display("p=132,25");
        }
        channel802154: ConnectionManager {
            parameters:
                @display("p=264,25");
        }
        channelControl: ChannelControl {
            @display("p=391,24");
        }
        hostEthernet: StandardHost {
            @display("r=,,#707070;p=66,105");
        }
        host80211: WirelessHost {
            @display("r=,,#707070;p=105,201");
        }
        host802154: WirelessHostWithBattery {
            @display("p=292,105");
        }
        hostInet80211: WirelessHost {
            @display("p=275,203");
        }
        hybridRouter: RouterWithBattery {
            @display("r=,,#707070;p=191,136;i=device/accesspoint");
        }
    connections:
        hostEthernet.ethg++ <--> {  datarate = 10Mbps; delay = 0.1us; } <--> hybridRouter.ethg++;
}

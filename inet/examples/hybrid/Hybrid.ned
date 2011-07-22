package mixnet.examples.hybrid;

import inet.nodes.inet.StandardHost;
import inet.nodes.inet.WirelessHost;
import org.mixim.base.connectionManager.ConnectionManager;
import org.mixim.base.modules.BaseWorldUtility;


//Network for testing a hybrid host (hybridRouter) containing different wired
//(from INET) and wireless (from MiXiM) NICs.
//
//This network contains several hosts, each equipped with a different type of
//NIC, in particular ethernet, 802.11 and 802.15.4 (TI_CC2420).
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
//      802.15.4) cannot interfere with each other yet.
network Hybrid
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        @display("bgb=$playgroundSizeX,$playgroundSizeY,white,,;bgp=10,50");
    submodules:
        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=159,25");

        }
        channel80211: ConnectionManager {
            parameters:
                @display("p=253,25");
        }
        channel802154: ConnectionManager {
            parameters:
                @display("p=369,25");
        }
        hostEthernet: StandardHost {
            @display("r=,,#707070;p=38,132");
            gates:
                ethg[1];

        }
        host80211: WirelessHost {
            @display("r=,,#707070;p=166,181");
            wlan[*].typename = "org.mixim.modules.nic.Nic80211";
        }
        host802154: WirelessHostWithBattery {
            @display("p=214,86");
            wlan[*].typename = "org.mixim.modules.nic.Nic802154_TI_CC2420";
        }
        hybridRouter: RouterWithBattery {
            @display("r=,,#707070;p=121,99;i=device/accesspoint");
            numRadios = 2;
            wlan[0].typename = "org.mixim.modules.nic.Nic80211";
            wlan[1].typename = "org.mixim.modules.nic.Nic802154_TI_CC2420";
            gates:
                ethg[1];
        }
    connections:
        hostEthernet.ethg[0] <--> { datarate = 10Mbps; delay = 0.1us; } <--> hybridRouter.ethg[0];
}

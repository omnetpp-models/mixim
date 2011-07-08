//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

#include "MixnetBridge.h"
#include <InterfaceTableAccess.h>
#include <cassert>
#include <AddressingInterface.h>
#include <Ieee802Ctrl_m.h>
#include <NetwToMacControlInfo.h>
#include <SimpleAddress.h>

Define_Module(MixnetBridge);

void MixnetBridge::initialize(int stage)
{
	if(stage == 0) {
		upperGateIn  = findGate("upperGateIn");
        upperGateOut = findGate("upperGateOut");
        lowerGateIn  = findGate("lowerGateIn");
        lowerGateOut = findGate("lowerGateOut");
        lowerControlIn  = findGate("lowerControlIn");
        lowerControlOut = findGate("lowerControlOut");

		//make sure no AddressingInterface module is in host
		AddressingInterface* addrScheme =
				FindModule<AddressingInterface*>
					::findSubModule(getParentModule());
		if(addrScheme) {
			opp_warning("Found addressing module in host.\n"
						"This will most likely break the functionality of this "
						"module. Please remove it!");
		}

		registerInterface();
	}
}

void MixnetBridge::handleMessage(cMessage *msg)
{
	if(msg->arrivedOn(upperGateIn)) {
		handleUpperMsg(msg);
	} else if(msg->arrivedOn(lowerGateIn)) {
		handleLowerMsg(msg);
	} else {
		assert(msg->arrivedOn(lowerControlIn));

		ev << "Dumped control message " << msg << " from MAC layer." << endl;

		delete msg;
	}
}

void MixnetBridge::handleUpperMsg(cMessage *msg)
{
	//remove INET control info
	assert(dynamic_cast<Ieee802Ctrl*>(msg->getControlInfo()));
	Ieee802Ctrl* inetCtrl = static_cast<Ieee802Ctrl*>(msg->removeControlInfo());

	//create and attach MiXiM control info
	NetwToMacControlInfo* miximCtrl = new NetwToMacControlInfo(inetCtrl->getDest());
	msg->setControlInfo(miximCtrl);

	delete inetCtrl;

	//forward to lower layer (NIC)
	send(msg, lowerGateOut);
}

void MixnetBridge::handleLowerMsg(cMessage *msg)
{
	//just forward to upper layer
	send(msg, upperGateOut);
}

cModule* MixnetBridge::findMyNic() {
	cGate* lowerOutDest = gate(lowerGateOut)->getNextGate();
	if(lowerOutDest == 0) {
		opp_error("Can't find NIC module for this bridge because lowerGateOut "
				  "is not connected to it!");
	}

	return lowerOutDest->getOwnerModule();
}

void MixnetBridge::registerInterface()
{
	cModule* nic = findMyNic();
    InterfaceEntry *e = new InterfaceEntry();

    // interface name: NIC module's name without special
    // characters ([])
    char *interfaceName = new char[strlen(nic->getFullName()) + 1];
    char *d = interfaceName;
    for (const char *s = nic->getFullName(); *s; s++)
        if (isalnum(*s))
            *d++ = *s;
    *d = '\0';

    e->setName(interfaceName);
    delete [] interfaceName;

	// this MAC address must be the same as the one in BaseMacLayer
	MACAddress myINETMacAddr = MACAddress(nic->getId());
    e->setMACAddress(myINETMacAddr);

    // generate interface identifier for IPv6
    e->setInterfaceToken(myINETMacAddr.formInterfaceIdentifier());

    // MTU on 802.11 = ?
    e->setMtu(par("mtu"));            // FIXME

    // capabilities
    e->setBroadcast(true);
    e->setMulticast(true);
    e->setPointToPoint(false);

    // add
    IInterfaceTable *ift = InterfaceTableAccess().get();
    ift->addInterface(e, this);
}

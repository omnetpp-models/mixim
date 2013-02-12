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

#include "NetworkStackTrafficGen.h"

#include <cassert>

#include "Packet.h"
#include "BaseMacLayer.h"
#include "FindModule.h"
#include "NetwToMacControlInfo.h"
#include "AddressingInterface.h"

Define_Module(NetworkStackTrafficGen);

void NetworkStackTrafficGen::initialize(int stage)
{
	BaseLayer::initialize(stage);

	if(stage == 0) {
		world = FindModule<BaseWorldUtility*>::findGlobalModule();
		delayTimer   = new cMessage("delay-timer", TRAFFIC_TIMER);

		arp          = FindModule<ArpInterface*>::findSubModule(findHost());

		packetLength = par("packetLength");
		packetTime = par("packetTime");
		pppt = par("packetsPerPacketTime");
		burstSize = par("burstSize");
		destination = LAddress::L3Type(par("destination").longValue());

		nbPacketDropped = 0;
		BaseMacLayer::catPacketSignal.initialize();
	}
	else if (stage == 1) {
		AddressingInterface* addrScheme = FindModule<AddressingInterface*>
                                                    ::findSubModule(findHost());
		if(addrScheme) {
			myNetwAddr = addrScheme->myNetwAddr(this);
		} else {
			myNetwAddr = LAddress::L3Type( getId() );
		}
		if(burstSize > 0) {
			remainingBurst = burstSize;
			scheduleAt(dblrand() * packetTime * burstSize / pppt, delayTimer);
		}
	} else {

	}
}

NetworkStackTrafficGen::~NetworkStackTrafficGen() {
	cancelAndDelete(delayTimer);
}


void NetworkStackTrafficGen::finish()
{
	recordScalar("dropped", nbPacketDropped);
}

void NetworkStackTrafficGen::handleSelfMsg(cMessage *msg)
{
	switch( msg->getKind() )
	{
	case TRAFFIC_TIMER:
		assert(msg == delayTimer);


		sendBroadcast();

		remainingBurst--;

		if(remainingBurst == 0) {
			remainingBurst = burstSize;
			scheduleAt(simTime() + (dblrand()*1.4+0.3)*packetTime * burstSize / pppt, msg);
		} else {
			scheduleAt(simTime() + packetTime * 2, msg);
		}

		break;
	default:
		EV << "Unkown selfmessage! -> delete, kind: "<<msg->getKind() <<endl;
		delete msg;
		break;
	}
}


void NetworkStackTrafficGen::handleLowerMsg(cMessage *msg)
{
	Packet p(packetLength, 1, 0);
	emit(BaseMacLayer::catPacketSignal, &p);

	delete msg;
	msg = NULL;
}


void NetworkStackTrafficGen::handleLowerControl(cMessage *msg)
{
	if(msg->getKind() == BaseMacLayer::PACKET_DROPPED) {
		nbPacketDropped++;
	}
	delete msg;
	msg = NULL;
}

void NetworkStackTrafficGen::sendBroadcast()
{
	LAddress::L2Type macAddr;
	LAddress::L3Type netwAddr = destination;

	netwpkt_ptr_t pkt = new netwpkt_t(LAddress::isL3Broadcast( netwAddr ) ? "TRAFFIC->ALL" : "TRAFFIC->TO", LAddress::isL3Broadcast( netwAddr ) ? BROADCAST_MESSAGE : TARGET_MESSAGE);
	pkt->setBitLength(packetLength);

	Packet appPkt(packetLength, 0, 1);
	emit(BaseMacLayer::catPacketSignal, &appPkt);

	pkt->setSrcAddr(myNetwAddr);
	pkt->setDestAddr(netwAddr);

	if(LAddress::isL3Broadcast( netwAddr )) {
		macAddr = LAddress::L2BROADCAST;
	}
	else{
		macAddr = arp->getMacAddr(netwAddr);
	}

	NetwToMacControlInfo::setControlInfo(pkt, macAddr);

	sendDown(pkt);
}


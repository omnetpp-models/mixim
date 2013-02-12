/*
 * SimpleNetwLayer.h
 *
 *  Created on: 29.08.2008
 *      Author: Karl Wessel
 */

#ifndef SIMPLENETWLAYER_H_
#define SIMPLENETWLAYER_H_

#include <cassert>
#include <omnetpp.h>
#include <sstream>

#include "BaseModule.h"
#include "NetwPkt_m.h"
#include "SimpleAddress.h"
#include "MacToNetwControlInfo.h"
#include "NetwToMacControlInfo.h"
#include "BaseMacLayer.h"
#include "FindModule.h"

/**
 * @brief This is an implementation of a simple network layer
 * which provides only some simple routing (next hop) and
 * message forwarding (only switches).
 *
 * This network layer isn't a real network layer its only purpose
 * is to provide some message sending for the CSMA-Mac layer.
 *
 * At first there is a small "saying hello"-phase where the
 * several network layers saying hello to each other and creating
 * their routing table.
 *
 * After that phase the non-switch instances start to babbling randomly
 * to other instances without caring if they here them.
 * The switch instances does only provide packet forwarding from there on.
 *
 * The several instances can babble directly to each other or over
 * a switch instance.
 *
 * @ingroup exampleCSMA
 */
class SimpleNetwLayer : public BaseModule{
public:
	typedef NetwPkt    netwpkt_t;
	typedef netwpkt_t* netwpkt_ptr_t;
//--------members----------
private:
	/** @brief Copy constructor is not allowed.
	 */
	SimpleNetwLayer(const SimpleNetwLayer&);
	/** @brief Assignment operator is not allowed.
	 */
	SimpleNetwLayer& operator=(const SimpleNetwLayer&);

protected:
	bool isSwitch;
	/** @brief time after when the module gets bored and starts jabbering. */
	simtime_t boredTime;

	int maxTtl;

	LAddress::L3Type ip;

	int dataIn;
	int dataOut;

	cMessage* startJabberTimer;

	unsigned long runningSeqNumber;

	typedef std::map<LAddress::L3Type, LAddress::L2Type> RoutingTable;

	RoutingTable routingTable;

	enum NetwPktKind{
		HELLO_WORLD = 4200,
		JABBER,
		START_TO_JABBER
	};

//--------methods----------
protected:
	void scheduleJabbering(){
		if(startJabberTimer->isScheduled()){
			cancelEvent(startJabberTimer);
		}

		scheduleAt(simTime() + boredTime, startJabberTimer);
	}

	void broadcastHelloWorld() {
		assert(!ev.isDisabled());
		ev << "Broadcasting hello world.\n";
		netwpkt_ptr_t helloWorld = new netwpkt_t("helloWorld", HELLO_WORLD);

		helloWorld->setDestAddr(LAddress::L3BROADCAST);
		helloWorld->setSrcAddr(ip);
		helloWorld->setSeqNum(runningSeqNumber++);
		helloWorld->setTtl(maxTtl);

		NetwToMacControlInfo::setControlInfo(helloWorld, LAddress::L2BROADCAST);

		const_cast<cModule*>(getNode())->bubble("Hello World!");

		sendDown(helloWorld);
	}

	void sendDown(cPacket* pkt) {
		send(pkt, dataOut);
	}

	void forwardPacket(netwpkt_ptr_t pkt, const LAddress::L2Type& nextHop){
		netwpkt_ptr_t fwd = new netwpkt_t(pkt->getName(), pkt->getKind());

		fwd->setDestAddr(pkt->getDestAddr());
		fwd->setSrcAddr(pkt->getSrcAddr());
		fwd->setSeqNum(pkt->getSeqNum());
		fwd->setTtl(pkt->getTtl() - 1);

		NetwToMacControlInfo::setControlInfo(fwd, nextHop);

		sendDown(fwd);
	}

	void handleHelloWorld(netwpkt_ptr_t pkt){

		//who said hello?
		const LAddress::L3Type& srcIP = pkt->getSrcAddr();

		//we already know ourself...
		if (srcIP == ip){
			delete pkt;
			return;
		}

		//do we already know him?
		if(routingTable.count(srcIP) == 0){
			//if not add him with the mac address of the previous hop
			MacToNetwControlInfo* cInfo = static_cast<MacToNetwControlInfo*>(pkt->getControlInfo());

			const LAddress::L2Type& prevHop = cInfo->getLastHopMac();

			routingTable[srcIP] = prevHop;

			std::stringstream osBuff(std::stringstream::out);
			osBuff << "Got hello from " << srcIP;
			const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
			ev << osBuff.str() << std::endl;
		}

		//if we are a switch and the time to live of the packet
		//hasn't exceeded yet forward it
		if(isSwitch){
			if(pkt->getTtl() > 0) {
				forwardPacket(pkt, LAddress::L2BROADCAST);

				std::stringstream osBuff(std::stringstream::out);
				osBuff << srcIP << " said hello!";
				const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
				ev << osBuff.str() << std::endl;
			}
		} else {
			//otherwise reset the bored timer after when we will start jabbering
			scheduleJabbering();
		}

		delete pkt;
	}

	void jabberToSomeone(){
		assert(!isSwitch);
		assert(routingTable.size() > 0);
		int target = intrand(routingTable.size());


		RoutingTable::const_iterator it = routingTable.begin();
		for(int i = 0; i < target; ++i)
			++it;

		ev << "Jabbering - Routingtablesize:" << routingTable.size() << "  target:" << target << "  dest:" << it->first << endl;

		netwpkt_ptr_t jabber = new netwpkt_t("jabber", JABBER);

		jabber->setDestAddr(it->first);
		jabber->setSrcAddr(ip);
		jabber->setSeqNum(runningSeqNumber++);
		jabber->setTtl(maxTtl);

		NetwToMacControlInfo::setControlInfo(jabber, it->second);

		std::stringstream osBuff(std::stringstream::out);
		osBuff << "Babbling with " << it->first;
		const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
		ev << osBuff.str() << std::endl;
		sendDown(jabber);

		scheduleJabbering();
	}

	void handleIncomingJabber(netwpkt_ptr_t pkt){
		if(isSwitch) {
			if(pkt->getDestAddr() != ip){
				assert(pkt->getTtl() > 0);
				assert(routingTable.count(pkt->getDestAddr()) > 0);

				LAddress::L2Type nextHop = routingTable[pkt->getDestAddr()];

				std::stringstream osBuff(std::stringstream::out);
				osBuff << pkt->getSrcAddr() << " babbles with " << pkt->getDestAddr();
				const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
				ev << osBuff.str() << std::endl;

				forwardPacket(pkt, nextHop);
			} else {
				std::stringstream osBuff(std::stringstream::out);
				osBuff << pkt->getSrcAddr() << " babbles with me. But I'm a serious switch, I do not babble...";
				const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
				ev << osBuff.str() << std::endl;
			}
		} else {
			assert(pkt->getDestAddr() == ip);

			std::stringstream osBuff(std::stringstream::out);
			osBuff << "Got babbling from " << pkt->getSrcAddr();
			const_cast<cModule*>(getNode())->bubble(osBuff.str().c_str());
			ev << osBuff.str() << std::endl;
		}

		delete pkt;
	}

public:
	SimpleNetwLayer()
		: BaseModule()
		, isSwitch(false)
		, boredTime()
		, maxTtl(0)
		, ip()
		, dataIn(-1)
		, dataOut(-1)
		, startJabberTimer(NULL)
		, runningSeqNumber(0)
		, routingTable()
	{}
	virtual ~SimpleNetwLayer() {
		cancelAndDelete(startJabberTimer);
	}

	virtual void initialize(int stage){

		if(stage == 0){
			dataOut = findGate("lowerLayerOut");
			dataIn = findGate("lowerLayerIn");

			isSwitch = par("isSwitch").boolValue();

			if(isSwitch) {
				FindModule<>::findHost(this)->getDisplayString().setTagArg("i",0,"device/accesspoint");
			}
			ip = LAddress::L3Type(par("ip").longValue());
			maxTtl = par("maxTtl").longValue();
			boredTime = par("boredTime").doubleValue();
		} else if(stage == 1) {
			startJabberTimer = new cMessage("jabber!", START_TO_JABBER);
			broadcastHelloWorld();
		}
	}

	virtual void handleMessage(cMessage* msg){

		switch(msg->getKind()){
		case HELLO_WORLD:
			handleHelloWorld(static_cast<netwpkt_ptr_t>(msg));
			break;
		case START_TO_JABBER:
			jabberToSomeone();
			break;
		case JABBER:
			handleIncomingJabber(static_cast<netwpkt_ptr_t>(msg));
			break;

		case BaseMacLayer::PACKET_DROPPED:
			ev << "Packet dropped by MAC layer." << endl;
			delete msg;
			break;

		default:
			error("unknown packet type of packet %s", msg->getName());
			break;
		}
	}


};

#endif /* SIMPLENETWLAYER_H_ */

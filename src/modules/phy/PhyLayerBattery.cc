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

#include "PhyLayerBattery.h"

#include "Decider80211MultiChannel.h"
#include "MacToPhyControlInfo.h"
#include "MiXiMMacPkt.h"

Define_Module(PhyLayerBattery);

void PhyLayerBattery::initialize(int stage) {
	PhyLayer::initialize(stage);
	if (stage == 0) {
		cModule *const pNic = getNic();

		numActivities = hasPar("numActivities") ? par("numActivities").longValue() : 5;

		/* parameters belong to the NIC, not just phy layer
		 *
		 * if/when variable transmit power is supported, txCurrent
		 * should be specified as an xml table of available transmit
		 * power levels and corresponding txCurrent */
		sleepCurrent   = rxCurrent      = decodingCurrentDelta = txCurrent   = 0;
		setupRxCurrent = setupTxCurrent = rxTxCurrent          = txRxCurrent = 0;
		sleepCurrent         = pNic->par( "sleepCurrent" );
		rxCurrent            = pNic->par( "rxCurrent" );
		if (pNic->hasPar("decodingCurrentDelta"))
		    decodingCurrentDelta = pNic->par( "decodingCurrentDelta" );
		txCurrent            = pNic->par( "txCurrent" );
		setupRxCurrent       = pNic->par( "setupRxCurrent" );
		setupTxCurrent       = pNic->par( "setupTxCurrent" );
		rxTxCurrent          = pNic->par( "rxTxCurrent" );
		txRxCurrent          = pNic->par( "txRxCurrent" );
	} else {
		registerWithBattery("physical layer", numActivities);
		setRadioCurrent(radio->getCurrentState());
	}
}

Decider* PhyLayerBattery::getDeciderFromName(const std::string& name, ParameterMap& params) {
    params["decodingCurrentDelta"] = cMsgPar("decodingCurrentDelta").setDoubleValue(decodingCurrentDelta);

	if(name == "Decider80211Battery") {
		return createDecider<Decider80211Battery>(params);
	}
	if(name == "Decider80211MultiChannel") {
		return createDecider<Decider80211MultiChannel>(params);
	}

	return PhyLayer::getDeciderFromName(name, params);
}

void PhyLayerBattery::drawCurrent(double amount, int activity) {
	if(radio->getCurrentState() == MiximRadio::RX) {
		if(amount != 0.0) {
			MiximBatteryAccess::drawCurrent(rxCurrent + amount, DECIDER_ACCT + activity);
		} else {
			MiximBatteryAccess::drawCurrent(rxCurrent, RX_ACCT);
		}
	} else {
		opp_warning("Decider wanted to change power consumption while radio not in state RX.");
	}
}

void PhyLayerBattery::handleUpperMessage(cMessage* msg) {
	if (battery && battery->getState() != HostState::ACTIVE) {
		coreEV<< "host has FAILED, dropping msg " << msg->getName() << endl;
		delete msg;
		return;
	}

	macpkt_ptr_t pkt = static_cast<macpkt_ptr_t>(msg);
	MacToPhyControlInfo* cInfo = static_cast<MacToPhyControlInfo*>(pkt->getControlInfo());

	double current = calcTXCurrentForPacket(pkt, cInfo);

	if(current > 0) {
		MiximBatteryAccess::drawCurrent(current, TX_ACCT);
	}

	PhyLayer::handleUpperMessage(msg);
}

void PhyLayerBattery::handleAirFrame(airframe_ptr_t frame) {
	if (battery && battery->getState() != HostState::ACTIVE) {
		coreEV<< "host has FAILED, dropping air frame msg " << frame->getName() << endl;
		delete frame;
		return;
	}
	PhyLayer::handleAirFrame(frame);
}

void PhyLayerBattery::handleHostState(const HostState& state) {
	if (state.get() != HostState::ACTIVE && radio->getCurrentState() != MiximRadio::SLEEP) {
		coreEV<< "host is no longer in active state (maybe FAILED, SLEEP, OFF or BROKEN), force into sleep state!" << endl;
		setRadioState(MiximRadio::SLEEP);
		// it would be good to create a radioState OFF, as well
	}
}

void PhyLayerBattery::finishRadioSwitching(bool bSendCtrlMsg /*= true */) {
	PhyLayer::finishRadioSwitching(bSendCtrlMsg);

	setRadioCurrent(radio->getCurrentState());
}

void PhyLayerBattery::setSwitchingCurrent(int from, int to) {
	double current = 0;

	if (from == to)
	    return;

	switch(from) {
        case MiximRadio::RX:
            switch(to) {
                case MiximRadio::SLEEP:
                    current = rxCurrent;
                    break;
                case MiximRadio::TX:
                    current = rxTxCurrent;
                    break;
                default:
                    opp_error("Unknown radio switch! From RX to %d", to);
                    break;
            }
            break;

        case MiximRadio::TX:
            switch(to) {
                case MiximRadio::SLEEP:
                    current = txCurrent;
                    break;
                case MiximRadio::RX:
                    current = txRxCurrent;
                    break;
                default:
                    opp_error("Unknown radio switch! From TX to %d", to);
                    break;
            }
            break;

        case MiximRadio::SLEEP:
            switch(to) {
                case MiximRadio::TX:
                    current = setupTxCurrent;
                    break;
                case MiximRadio::RX:
                    current = setupRxCurrent;
                    break;
                default:
                    opp_error("Unknown radio switch! From SLEEP to %d", to);
                    break;
            }
            break;

        default:
            opp_error("Unknown radio state: %d", from);
            break;
	}

	MiximBatteryAccess::drawCurrent(current, SWITCHING_ACCT);
}

void PhyLayerBattery::setRadioCurrent(int rs) {
	switch(rs) {
	case MiximRadio::RX:
		MiximBatteryAccess::drawCurrent(rxCurrent, RX_ACCT);
		break;
	case MiximRadio::TX:
		MiximBatteryAccess::drawCurrent(txCurrent, TX_ACCT);
		break;
	case MiximRadio::SLEEP:
		MiximBatteryAccess::drawCurrent(sleepCurrent, SLEEP_ACCT);
		break;
	default:
		opp_error("Unknown radio state: %d", rs);
		break;
	}
}

simtime_t PhyLayerBattery::setRadioState(int rs) {
	Enter_Method_Silent();
	int prevState = radio->getCurrentState();

	if (battery) {
		if (battery && battery->getState() != HostState::ACTIVE && rs != MiximRadio::SLEEP && prevState != rs) {
			coreEV << "can not switch radio state, host is not in active state!" << endl;
			return Decider::notAgain;
		}
	}

	simtime_t endSwitch = PhyLayer::setRadioState(rs);

	if(endSwitch >= SIMTIME_ZERO) {
		if(radio->getCurrentState() == MiximRadio::SWITCHING) {
			setSwitchingCurrent(prevState, rs);
		}
		else {
		    setRadioCurrent(radio->getCurrentState());
		}
	}

	return endSwitch;
}

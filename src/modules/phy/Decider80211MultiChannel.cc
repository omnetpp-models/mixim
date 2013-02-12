/*
 * Decider80211MultiChannel.cpp
 *
 *  Created on: Mar 22, 2011
 *      Author: karl
 */

#include "Decider80211MultiChannel.h"

#include "DeciderResult80211.h"
#include "utility/Consts80211.h"
#include "MiXiMAirFrame.h"

Decider80211MultiChannel::~Decider80211MultiChannel()
{
}

DeciderResult* Decider80211MultiChannel::createResult(const airframe_ptr_t frame) const {
    DeciderResult80211* result = static_cast<DeciderResult80211*>(Decider80211Battery::createResult(frame));

	if(result->isSignalCorrect() && frame->getChannel() != phy->getCurrentRadioChannel()) {
		deciderEV << "Channel changed during reception. packet is lost!\n";
		DeciderResult80211* oldResult = result;

		result = new DeciderResult80211(false, oldResult->getBitrate(), oldResult->getSnr());
		delete oldResult;
	}

	return result;
}

void Decider80211MultiChannel::channelChanged(int newChannel) {
	assert(1 <= newChannel && newChannel <= 14);
	centerFrequency = CENTER_FREQUENCIES[newChannel];

	Decider80211Battery::channelChanged(newChannel);
}

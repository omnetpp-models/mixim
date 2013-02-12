/*
 * Decider80211.cc
 *
 *  Created on: 11.02.2009
 *      Author: karl wessel
 */

#include "./Decider80211.h"

#include <cassert>

#ifdef MIXIM_INET
#include <INETDefs.h>
#define ERFC(x) erfc(x)
#else
#include "FWMath.h"
#define ERFC(x) FWMath::erfc(x)
#endif

#include "DeciderResult80211.h"
#include "messages/Mac80211Pkt_m.h"
#include "utility/Consts80211.h"
#include "Mapping.h"
#include "MiXiMAirFrame.h"

Decider80211::Decider80211( DeciderToPhyInterface* phy
                          , double                 sensitivity
                          , int                    myIndex
                          , bool                   debug )
    : BaseDecider(phy, sensitivity, myIndex, debug)
    , snrThreshold(0)
    , centerFrequency(0)
{
	assert(1                             <= phy->getCurrentRadioChannel());
	assert(phy->getCurrentRadioChannel() <= 14);
	centerFrequency = CENTER_FREQUENCIES[phy->getCurrentRadioChannel()];
}

bool Decider80211::initFromMap(const ParameterMap& params) {
    ParameterMap::const_iterator it           = params.find("threshold");
    bool                         bInitSuccess = true;
    if(it != params.end()) {
        snrThreshold = ParameterMap::mapped_type(it->second).doubleValue();
    }
    else {
        bInitSuccess = false;
        opp_warning("No threshold defined in config.xml for Decider80211!");
    }
    return BaseDecider::initFromMap(params) && bInitSuccess;
}

double Decider80211::getFrameReceivingPower(airframe_ptr_t frame) const
{
	// get the receiving power of the Signal at start-time and center frequency
	Signal& signal = frame->getSignal();
	Argument argStart(DimensionSet::timeFreqDomain);

	argStart.setTime(MappingUtils::post(signal.getReceptionStart()));
	argStart.setArgValue(Dimension::frequency, centerFrequency);

	return signal.getReceivingPower()->getValue(argStart);
}

BaseDecider::channel_sense_rssi_t Decider80211::calcChannelSenseRSSI(simtime_t_cref start, simtime_t_cref end) const {
    rssi_mapping_t pairMapMaxEnd = calculateRSSIMapping(start, end);
	Argument       argMin(getLowerBandFrequency(start));
	Argument       argMax(getUpperBandFrequency(end));

	Mapping::argument_value_t rssi = MappingUtils::findMax(*pairMapMaxEnd.first, argMin, argMax, Argument::MappedZero /* the value if no maximum will be found */);

	delete pairMapMaxEnd.first;
	return std::make_pair(rssi, pairMapMaxEnd.second);
}

DeciderResult* Decider80211::createResult(const airframe_ptr_t frame) const
{
	// check if the snrMapping is above the Decider's specific threshold,
	// i.e. the Decider has received it correctly

	// first collect all necessary information
	Mapping* snrMap = calculateSnrMapping(frame);
	assert(snrMap);

	const Signal& s     = frame->getSignal();
	simtime_t     start = s.getReceptionStart();
	simtime_t     end   = s.getReceptionEnd();

	start = start + RED_PHY_HEADER_DURATION; //its ok if the phy header is received only
											 //partly - TODO: maybe solve this nicer

	Argument argMin(getLowerBandFrequency(start));
	Argument argMax(getUpperBandFrequency(end));

	Mapping::argument_value_t snirMin = MappingUtils::findMin(*snrMap, argMin, argMax, Argument::MappedZero /* the value if no minimum will be found */);

	deciderEV << " snrMin: " << snirMin << endl;

	ConstMappingIterator* bitrateIt = s.getBitrate()->createConstIterator();
	bitrateIt->next(); //iterate to payload bitrate indicator
	double payloadBitrate = bitrateIt->getValue();
	delete bitrateIt;

	DeciderResult80211* result = NULL;

	if (snirMin > snrThreshold) {
		if(packetOk(snirMin, frame->getBitLength() - (int)PHY_HEADER_LENGTH, payloadBitrate)) {
			result = new DeciderResult80211(!frame->hasBitError(), payloadBitrate, snirMin);
		} else {
			deciderEV << "Packet has BIT ERRORS! It is lost!\n";
			result = new DeciderResult80211(false, payloadBitrate, snirMin);
		}
	} else {
		deciderEV << "Packet has ERRORS! It is lost!\n";
		result = new DeciderResult80211(false, payloadBitrate, snirMin);
	}

	delete snrMap;
	snrMap = 0;

	return result;
}

bool Decider80211::packetOk(double snirMin, int lengthMPDU, double bitrate) const
{
    double berHeader, berMPDU;

    berHeader = 0.5 * exp(-snirMin * BANDWIDTH / BITRATE_HEADER);
    //if PSK modulation
    if (bitrate == 1E+6 || bitrate == 2E+6) {
        berMPDU = 0.5 * exp(-snirMin * BANDWIDTH / bitrate);
    }
    //if CCK modulation (modeled with 16-QAM)
    else if (bitrate == 5.5E+6) {
        berMPDU = 2.0 * (1.0 - 1.0 / sqrt(pow(2.0, 4))) * ERFC(sqrt(2.0*snirMin * BANDWIDTH / bitrate));
    }
    else {                       // CCK, modelled with 256-QAM
        berMPDU = 2.0 * (1.0 - 1.0 / sqrt(pow(2.0, 8))) * ERFC(sqrt(2.0*snirMin * BANDWIDTH / bitrate));
    }

    //probability of no bit error in the PLCP header
    double headerNoError = pow(1.0 - berHeader, HEADER_WITHOUT_PREAMBLE);

    //probability of no bit error in the MPDU
    double MpduNoError = pow(1.0 - berMPDU, lengthMPDU);
    deciderEV << "berHeader: " << berHeader << " berMPDU: " << berMPDU << endl;
    double rand = dblrand();

    //if error in header
    if (rand > headerNoError)
        return (false);
    else
    {
        rand = dblrand();

        //if error in MPDU
        if (rand > MpduNoError)
            return (false);
        //if no error
        else
            return (true);
    }
}

/*
 * Decider802154Narrow.cc
 *
 *  Created on: 11.02.2009
 *      Author: karl wessel
 */

#include "Decider802154Narrow.h"

#include <cmath>

#ifdef MIXIM_INET
#include <INETDefs.h>
#define ERFC(x)   erfc(x)
#define MW2DBM(x) (10.0*log10(x))
#else
#include "FWMath.h"
#define ERFC(x)   FWMath::erfc(x)
#define MW2DBM(x) FWMath::mW2dBm(x)
#endif

#include "DeciderResult802154Narrow.h"
#include "MacPkt_m.h"
#include "PhyToMacControlInfo.h"
#include "AirFrame_m.h"
#include "Mapping.h"

bool Decider802154Narrow::syncOnSFD(AirFrame* frame) {
	double BER;
	double sfdErrorProbability;

	BER = evalBER(frame);
	sfdErrorProbability = 1.0 - pow((1.0 - BER), sfdLength);

	return sfdErrorProbability < uniform(0, 1, 0);
}

double Decider802154Narrow::evalBER(AirFrame* frame) {
	Signal& signal = frame->getSignal();

	simtime_t time = MappingUtils::post(phy->getSimTime());
	double rcvPower = signal.getReceivingPower()->getValue(Argument(time));

	ConstMapping* noise = calculateRSSIMapping(time, time, frame);

	Argument argStart(time);
	double noiseLevel = noise->getValue(argStart);

	delete noise;

	return getBERFromSNR(rcvPower/noiseLevel); //std::max(0.5 * exp(-rcvPower / (2 * noiseLevel)), DEFAULT_BER_LOWER_BOUND);
}

simtime_t Decider802154Narrow::processNewSignal(AirFrame* frame) {
	//if we are already receiving another signal this is noise
	if(currentSignal.first != 0) {
		return notAgain;
	}

	if(frame->getChannel() != phy->getCurrentRadioChannel()) {
		// we cannot synchronize on a frame on another channel.
		return notAgain;
	}

	currentSignal.first = frame;
	currentSignal.second = EXPECT_HEADER;
	Signal& s = frame->getSignal();
	double bitrate = s.getBitrate()->getValue(Argument(s.getReceptionStart()));
	simtime_t phyHeaderDuration = ((double) phyHeaderLength)/bitrate;
	return s.getReceptionStart() + phyHeaderDuration;

}

simtime_t Decider802154Narrow::processSignalHeader(AirFrame* frame)
{
	if (!syncOnSFD(frame)) {
		currentSignal.first = 0;
		//channel is back idle
		setChannelIdleStatus(true);
		return notAgain;
	}

	// store this frame as signal to receive and set state
//	currentSignal.first = frame;
	currentSignal.second = EXPECT_END;

	//channel is busy now
	setChannelIdleStatus(false);

	//TODO: publish rssi and channel state
	// Inform the MAC that we started receiving a frame
	phy->sendControlMsgToMac(new cMessage("start_rx",RECEPTION_STARTED));
	Signal& s = frame->getSignal();
	return s.getReceptionEnd();
}

simtime_t Decider802154Narrow::processSignalEnd(AirFrame* frame)
{
	ConstMapping* snrMapping = calculateSnrMapping(frame);

	Signal& s = frame->getSignal();
	simtime_t start = s.getReceptionStart();
	simtime_t end = s.getReceptionEnd();

	AirFrameVector channel;
	phy->getChannelInfo(start, end, channel);
	bool hasInterference = channel.size() > 1;

	if(hasInterference) {
		nbFramesWithInterference++;
	} else {
		nbFramesWithoutInterference++;
	}

	double bitrate = s.getBitrate()->getValue(Argument(start));

	double avgBER = 0;
	double bestBER = 0.5;
	double snirAvg = 0;
	bool noErrors = true;
	double ber;
	double errorProbability;

	simtime_t receivingStart = MappingUtils::post(start);
	Argument argStart(receivingStart);
	ConstMappingIterator* iter = snrMapping->createConstIterator(argStart);
	double snirMin = iter->getValue();
	// Evaluate bit errors for each snr value
	// and stops as soon as we have an error.
	// TODO: add error correction code.

	simtime_t curTime = iter->getPosition().getTime();
	simtime_t snrDuration;
	while(curTime < end) {
		//get SNR for this interval
		double snr = iter->getValue();

		//determine end of this interval
		simtime_t nextTime = end;	//either the end of the signal...
		if(iter->hasNext()) {		//or the position of the next entry
			const Argument& argNext = iter->getNextPosition();
			nextTime = std::min(argNext.getTime(), nextTime);
			iter->next();	//the iterator will already point to the next entry
		}

		if (noErrors) {
			snrDuration = nextTime - curTime;

			int nbBits = int (SIMTIME_DBL(snrDuration) * bitrate);

			// non-coherent detection of m-ary orthogonal signals in an AWGN
			// Channel
			// Digital Communications, John G. Proakis, section 4.3.2
			// p. 212, (4.3.32)
			//  Pm = sum(n=1,n=M-1){(-1)^(n+1)choose(M-1,n) 1/(n+1) exp(-nkgamma/(n+1))}
			// Pb = 2^(k-1)/(2^k - 1) Pm


			ber     = getBERFromSNR(snr);
			avgBER  = ber*nbBits;
			snirAvg = snirAvg + snr*SIMTIME_DBL(snrDuration);

			if(ber < bestBER) {
				bestBER = ber;
			}
			errorProbability = 1.0 - pow((1.0 - ber), nbBits);
			noErrors = errorProbability < uniform(0, 1);
		}
		if (snr < snirMin)
			snirMin = snr;

		curTime = nextTime;
	}
	delete iter;
	delete snrMapping;

	avgBER = avgBER / frame->getBitLength();
	snirAvg = snirAvg / (end - start);
	//double rssi = 10*log10(snirAvg);
	double rssi = calcChannelSenseRSSI(start, end);
	if (noErrors)
	{
		phy->sendUp(frame,
					new DeciderResult802154Narrow(true, bitrate, snirMin, avgBER, rssi));
		if(recordStats) {
		  snirReceived.record(10*log10(snirMin));  // in dB
		}
	} else {
		MacPkt* mac = static_cast<MacPkt*> (frame->decapsulate());
		mac->setName("BIT_ERRORS");
		mac->setKind(PACKET_DROPPED);

		PhyToMacControlInfo::setControlInfo(mac, new DeciderResult802154Narrow(false, bitrate, snirMin, avgBER, rssi));
		phy->sendControlMsgToMac(mac);
		if(recordStats) {
		  snirDropped.record(10*log10(snirMin));  // in dB
		}
		if(hasInterference) {
			nbFramesWithInterferenceDropped++;
		} else {
			nbFramesWithoutInterferenceDropped++;
		}
	}

	//decoding is done
	currentSignal.first = 0;

	//channel is back idle
	setChannelIdleStatus(true);

	//TODO: publish rssi and channel state
	return notAgain;
}

double Decider802154Narrow::n_choose_k(int n, int k) {
	if (n < k)
		return 0.0;

	const int       iK     = (k<<1) > n ? n-k : k;
	const double    dNSubK = (n-iK);
	register int    i      = 1;
	register double dRes   = i > iK ? 1.0 : (dNSubK+i);

	for (++i; i <= iK; ++i) {
		dRes *= dNSubK+i;
		dRes /= i;
	}
	return dRes;
}

double Decider802154Narrow::getBERFromSNR(double snr) {
	double ber = BER_LOWER_BOUND;
	double sum_k = 0;
	if(modulation == "msk") {
		// valid for IEEE 802.15.4 868 MHz BPSK modulation
		ber = 0.5 *  ERFC(sqrt(snr));
	} else if (modulation == "oqpsk16") {
		// valid for IEEE 802.15.4 2.45 GHz OQPSK modulation
		const double dSNRFct = 20.0 * snr;
		register int k       = 2;
		/* following loop was optimized by using n_choose_k symmetries
		for (k=2; k <= 16; ++k) {
			sum_k += pow(-1.0, k) * n_choose_k(16, k) * exp(dSNRFct * (1.0 / k - 1.0));
		}
		*/
		// n_choose_k(16, k) == n_choose_k(16, 16-k)
		for (; k < 8; k += 2) {
			// k will be 2, 4, 6 (symmetric values: 14, 12, 10)
			sum_k += n_choose_k(16, k) * (exp(dSNRFct * (1.0 / k - 1.0)) + exp(dSNRFct * (1.0 / (16 - k) - 1.0)));
		}
		// for k =  8 (which does not have a symmetric value)
		k = 8; sum_k += n_choose_k(16, k) * exp(dSNRFct * (1.0 / k - 1.0));
		for (k = 3; k < 8; k += 2) {
			// k will be 3, 5, 7 (symmetric values: 13, 11, 9)
			sum_k -= n_choose_k(16, k) * (exp(dSNRFct * (1.0 / k - 1.0)) + exp(dSNRFct * (1.0 / (16 - k) - 1.0)));
		}
		// for k = 15 (because of missing k=1 value)
		k   = 15; sum_k -= n_choose_k(16, k) * exp(dSNRFct * (1.0 / k - 1.0));
		// for k = 16 (because of missing k=0 value)
		k   = 16; sum_k += n_choose_k(16, k) * exp(dSNRFct * (1.0 / k - 1.0));
		ber = (8.0 / 15) * (1.0 / 16) * sum_k;
	} else if(modulation == "gfsk") {
		// valid for Bluetooth 4.0 PHY mandatory base rate 1 Mbps
		// Please note that this is not the correct expression for
		// the enhanced data rates (EDR), which uses another modulation.
		ber = 0.5 * ERFC(sqrt(0.5 * snr));
	} else {
		opp_error("The selected modulation is not supported.");
	}
	if(recordStats) {
	  berlog.record(ber);
	  snrlog.record(MW2DBM(snr));
	}
	return std::max(ber, BER_LOWER_BOUND);
}

void Decider802154Narrow::channelChanged(int /*newChannel*/) {
	//TODO: stop receiving
	;
}

void Decider802154Narrow::finish() {

	// record scalars through the interface to the PHY-Layer
	phy->recordScalar("nbFramesWithInterference", nbFramesWithInterference);
	phy->recordScalar("nbFramesWithoutInterference", nbFramesWithoutInterference);
	phy->recordScalar("nbFramesWithInterferenceDropped", nbFramesWithInterferenceDropped);
	phy->recordScalar("nbFramesWithoutInterferenceDropped", nbFramesWithoutInterferenceDropped);
}

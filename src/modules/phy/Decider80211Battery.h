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

#ifndef DECIDER80211BATTERY_H_
#define DECIDER80211BATTERY_H_

#include "MiXiMDefs.h"
#include "./Decider80211.h"

/**
 * @brief Extends Decider80211 by drawing power during receiving
 * of messages.
 *
 * @ingroup decider
 * @ingroup power
 * @ingroup ieee80211
 */
class MIXIM_API Decider80211Battery : public Decider80211 {
protected:
	/**
	 * @brief Stores the current delta in mA to draw during reception
	 * of AirFrames.
	 *
	 * Stores the delta to add to the base current drawn during RX state
	 * when no frame is received but we are listening.
	 */
	double decodingCurrentDelta;

	/**
	 * @brief Defines the power consuming activities (accounts) of
	 * the decider.
	 */
	enum Activities {
		DECODING_ACCT=0
	};
public:
	/** @brief Standard Decider constructor.
	 */
	Decider80211Battery( DeciderToPhyInterface* phy
                       , double                 sensitivity
                       , int                    myIndex
                       , bool                   debug )
        : Decider80211(phy, sensitivity, myIndex, debug)
	    , decodingCurrentDelta(0)
	{}

	/** @brief Initialize the decider from XML map data.
	 *
	 * This method should be defined for generic decider initialization.
	 *
	 * @param params The parameter map which was filled by XML reader.
	 *
	 * @return true if the initialization was successfully.
	 */
	virtual bool initFromMap(const ParameterMap& params);

	/**
	 * @brief Draws either idle or rx current, depending on the
	 * "isIdle" state.
	 */
	virtual void channelStateChanged();

};

#endif /* DECIDER80211BATTERY_H_ */

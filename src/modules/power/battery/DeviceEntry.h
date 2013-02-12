/* -*- mode:c++ -*- ********************************************************
 * Energy Framework for Omnet++, version 0.9
 *
 * Author:  Laura Marie Feeney
 *
 * Copyright 2009 Swedish Institute of Computer Science.
 *
 * This software is provided `as is' and without any express or implied
 * warranties, including, but not limited to, the implied warranties of
 * merchantability and fitness for a particular purpose.
 *
 ***************************************************************************/
/*
 * per-device, per-activity energy data is shared between Battery and
 * BatteryStats using the DeviceEntry data structure
 *
 ***************************************************************************/

#ifndef DEVICEENTRY_H
#define DEVICEENTRY_H

#include "MiXiMDefs.h"

/** @brief per-device/per-account record of battery consumption, is
 * passed to BatteryStats on finish()
 *
 * For each device, maintain the current value of the current
 * being drawn by the device, the activity and time for which ongoing
 * current draw is being charged. The sum over the activities is the
 * total energy consumed by the device, but the sum of times is the
 * total active time, not necessarily the total lifetime.
 *
 * @ingroup power
 */
class MIXIM_API DeviceEntry
  {
  public:
	/** @brief Name of the device.*/
    opp_string  name;
    /** @brief Actual current drawn.*/
    double 	draw;
    /** @brief The activity/account currently drawing power.*/
    int		currentActivity;
    /** @brief The amount of different power drawing activities/acounts this
     * device has.*/
    int 	numAccts;
    /** @brief The power already drawn for each activity/account.*/
    double	*accts;
    /** @brief The time spend for each activity/account.*/
    simtime_t	*times;

    /** @brief New empty device entry.*/
    DeviceEntry()
    	: name()
      	, draw(0)
    	, currentActivity(-1)
    	, numAccts(0)
    	, accts(NULL)
    	, times(NULL)
    {}
    DeviceEntry(const DeviceEntry& o)
    	: name(o.name)
      	, draw(o.draw)
    	, currentActivity(o.currentActivity)
    	, numAccts(o.numAccts)
    	, accts(NULL)
    	, times(NULL)
    {
    	if (o.accts) {
    		accts = new double[numAccts];
    		for (int i = 0; i < numAccts; ++i) {
    			accts[i] = o.accts[i];
    		}
    	}
    	if (o.times) {
			times = new simtime_t[numAccts];
			for (int i = 0; i < numAccts; ++i) {
				times[i] = o.times[i];
			}
    	}
    }
    /**
     *  @brief  %DeviceEntry assignment operator.
     *  @param  copy  A %DeviceEntry of identical element and allocator types.
     *
     *  All the elements of @a copy are copied.
     */
    DeviceEntry& operator=(const DeviceEntry& copy) {
    	DeviceEntry Temp(copy);

    	swap(Temp);
    	return *this;
    }
    /**
     *  @brief  Swaps data with another %DeviceEntry.
     *  @param  s  A %DeviceEntry of the same element and allocator types.
     *
     *  This exchanges the elements between two DeviceEntry's in constant time.
     *  Note that the global std::swap() function is specialized such that
     *  std::swap(s1,s2) will feed to this function.
     */
    void swap(DeviceEntry& s) {
        std::swap(name, s.name);
        std::swap(draw, s.draw);
        std::swap(currentActivity, s.currentActivity);
        std::swap(numAccts, s.numAccts);
        std::swap(accts, s.accts);
        std::swap(times, s.times);
    }

    ~DeviceEntry() {
    	if (accts)
            delete [] accts;
    	if (times)
            delete [] times;
    }
  };

#endif

//

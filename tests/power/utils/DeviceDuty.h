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
#ifndef DEVICEDUTY_H
#define DEVICEDUTY_H


#include <omnetpp.h>
#include "MiximBatteryAccess.h"

#include "BatteryState.h"
#include "HostState.h"

/**
 *  @brief trivial device module with two-phase duty cycle
 *
 *  A trivial device module that has a fixed two-phase duty cycle, but
 *  is not actually connected to the operation of the host.  Is useful
 *  only for testing multiple accounts.  See DeviceDuty.ned for
 *  parameters.
 */
class DeviceDuty : public MiximBatteryAccess
{
private:
	/** @brief Copy constructor is not allowed.
	 */
	DeviceDuty(const DeviceDuty&);
	/** @brief Assignment operator is not allowed.
	 */
	DeviceDuty& operator=(const DeviceDuty&);

public:
	DeviceDuty()
		: MiximBatteryAccess()
		, on0(NULL)
		, gap01(NULL)
		, on1(NULL)
		, off(NULL)
		, period(0), dutyCycle0(0), current0(0), gap(0), dutyCycle1(0), current1(0), wakeup(0)
	{}

  virtual void initialize(int);
  virtual void handleMessage( cMessage* );
  virtual void handleHostState(const HostState& state);
  virtual void finish();
  ~DeviceDuty();

protected:

  enum DeviceState {
    ON0,
    GAP,
    ON1,
    OFF
  };

  enum Accounts {
    DUTY0=0,
    DUTY1,
    WAKE
  };

  cMessage *on0, *gap01, *on1, *off;

  double period, dutyCycle0, current0, gap, dutyCycle1, current1, wakeup;
};

#endif // DEVICEDUTY_H

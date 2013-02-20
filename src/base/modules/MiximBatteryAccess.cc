/*
 * MiximBatteryAccess.cc
 *
 *  Created on: Aug 26, 2009
 *      Author: Karl Wessel
 */

#include "base/modules/MiximBatteryAccess.h"

#include <cassert>

#include "FindModule.h"

MiximBatteryAccess::MiximBatteryAccess():
	BaseModule(),
	battery(NULL),
	deviceID(-1)
{}

MiximBatteryAccess::MiximBatteryAccess(unsigned stacksize):
	BaseModule(stacksize),
	battery(NULL),
	deviceID(-1)
{}

void MiximBatteryAccess::registerWithBattery(const std::string& name, int numAccounts)
{
	battery = FindModule<BaseBattery*>::findSubModule(findHost());

	if(!battery) {
		opp_warning("No battery module defined!");
	} else {
		deviceID = battery->registerDevice(name, numAccounts);
	}
}

void MiximBatteryAccess::draw(DrawAmount& amount, int account)
{
	if(!battery)
		return;

	battery->draw(deviceID, amount, account);
}

void MiximBatteryAccess::drawCurrent(double amount, int account)
{
	if(!battery)
		return;

	DrawAmount val(DrawAmount::CURRENT, amount);
	battery->draw(deviceID, val, account);
}

void MiximBatteryAccess::drawEnergy(double amount, int account)
{
	if(!battery)
		return;

	DrawAmount val(DrawAmount::ENERGY, amount);
	battery->draw(deviceID, val, account);
}

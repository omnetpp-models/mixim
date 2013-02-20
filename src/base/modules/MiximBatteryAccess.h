/*
 * BatteryAccess.h
 *
 *  Created on: Aug 26, 2009
 *      Author: karl
 */

#ifndef MIXIMBATTERYACCESS_H_
#define MIXIMBATTERYACCESS_H_

#include "MiXiMDefs.h"
#include "BaseModule.h"
#include "BaseBattery.h"

/**
 * @brief Extends BaseModule by several methods which provide
 * access to the battery module.
 *
 * @ingroup power
 * @ingroup baseModules
 * @author Karl Wessel
 */
class MIXIM_API MiximBatteryAccess : public BaseModule
{
    protected:
        /** @brief Stores pointer to the battery module. */
        BaseBattery* battery;

        /** @brief This devices id for the battery module. */
        int deviceID;

    protected:
        /**
         * @brief Registers this module as a device with the battery module.
         *
         * If no battery module is available than nothing happens.
         */
        void registerWithBattery(const std::string& name, int numAccounts);

        /**
         * @brief Draws the amount defined by the passed DrawAmount from the
         * battery on account of the passed account.
         *
         * If no battery module is available than nothing happens.
         */
        void draw(DrawAmount& amount, int account);

        /**
         * @brief Draws the passed amount of current (in mA) over time from the
         * battery on account of the passed account.
         *
         * If no battery module is available than nothing happens.
         */
        void drawCurrent(double amount, int account);

        /**
         * @brief Draws the passed amount of energy (in mWs) from the
         * battery on account of the passed account.
         *
         * If no battery module is available than nothing happens.
         */
        void drawEnergy(double amount, int account);

    public:
        MiximBatteryAccess();
        MiximBatteryAccess(unsigned stacksize);

    private:
        /** @brief Copy constructor is not allowed.
         */
        MiximBatteryAccess(const MiximBatteryAccess&);
        /** @brief Assignment operator is not allowed.
         */
        MiximBatteryAccess& operator=(const MiximBatteryAccess&);
};

#endif /* BATTERYACCESS_H_ */

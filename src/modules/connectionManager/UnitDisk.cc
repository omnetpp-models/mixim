#include "UnitDisk.h"

Define_Module(UnitDisk);

#ifndef udEV
#define udEV (ev.isDisabled()||!coreDebug) ? ev : ev << "UnitDisk: "
#endif

void UnitDisk::initialize(int stage)
{
    ConnectionManager::initialize(stage);
    if (stage == 0)
    {
        radioRange = par("radioRange").doubleValue();
        udEV << "UnitDisk initialised with range " << radioRange << endl;
    }
}


#include "BaseUtility.h"
#include "BaseModule.h"
#include "BaseWorldUtility.h"
#include "FindModule.h"
#include <assert.h>
#include "MobilityAccess.h"

Define_Module(BaseUtility);

void BaseUtility::initialize(int stage) {
	Blackboard::initialize(stage);

	if (stage == 0) {
        catHostState = subscribe(this, &hostState, findHost()->getId());
        hostState.set(HostState::ACTIVE);
	}
	else if(stage == 1) {
		cModule* host = findHost();
		//check if necessary host modules are available
		//mobility module
		if (!MobilityAccess().get()) {
			opp_warning("No mobility module found in host with index %d!", host->getIndex());
		}
	}
}

cModule *BaseUtility::findHost(void)
{
	return FindModule<>::findHost(this);
}

void BaseUtility::receiveBBItem(int category, const BBItem *details, int scopeModuleId)
{
    //BaseModule::receiveBBItem(category, details, scopeModuleId);

    if(category == catHostState)
    {
    	const HostState* state = static_cast<const HostState*>(details);
		hostState = *state;
		coreEV << "new HostState: " << hostState.info() << endl;
    }
}

std::string BaseUtility::logName(void)
{
    std::ostringstream ost;
	cModule *parent = findHost();
	parent->hasPar("logName") ?
		ost << parent->par("logName").stringValue() : ost << parent->getName();
	ost << "[" << parent->getIndex() << "]";
	return ost.str();
}

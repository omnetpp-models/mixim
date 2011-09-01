/**
 * This file has been merged from BaseUtility.h and Blackboard.h in
 * order to bring Blackboard's functionality to BaseUtility.
 *
 * Blackboard's comments have been copied since they describe the
 * migrated functionality.
 *
 *
 *
 */

#ifndef BASE_UTILITY_H
#define BASE_UTILITY_H

//BB start
#ifdef _MSC_VER
#pragma warning(disable : 4786)
#endif

#include <omnetpp.h>
#include "Blackboard.h"
#include "HostState.h"
#include "Coord.h"
/**
 * @brief Provides several utilities (mainly Blackboard functionality
 * for a host).
 *
 * @ingroup blackboard
 * @ingroup baseModules
 *
 * @author Andreas Koepke
 */

class BaseUtility : public Blackboard,
					public ImNotifiable
{
protected:
	/** @brief Function to get a pointer to the host module*/
	cModule *findHost(void);

    /** @brief BBItem category number of HostState*/
    int catHostState;

    /** @brief The hosts current state.*/
    HostState hostState;

protected:
    /**
     * @brief Function to get the logging name of the host
     *
     * The logging name is the ned module name of the host (unless the
     * host ned variable loggingName is specified). It can be used for
     * logging messages to simplify debugging in TKEnv.
     */
    std::string logName(void);

public:

    /** @brief Initializes mobility model parameters.*/
    virtual void initialize(int);

    /** @brief Get the current HostState
     *
     * NOTE: The correct host state is available from initialization-stage 1.
     */
    const HostState& getHostState() { return hostState; }

    /**
     * @brief Receive HostStates from BaseUtility to synchronize state.
     */
    virtual void receiveBBItem(int category, const BBItem *details, int scopeModuleId);
};

#endif


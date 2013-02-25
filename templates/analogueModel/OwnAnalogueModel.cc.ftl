<@setoutput path="${amName}.cc" />
${bannerComment}

#include "${amName}.h"

#include "MiXiMAirFrame.h"

${amName}::${amName}()
	: AnalogueModel()<#if par1Name!="">
	, ${par1Name}(0)</#if><#if par2Name!="">
	, ${par2Name}(0)</#if>
{}

${amName}::~${amName}() {}

bool ${amName}::initFromMap(const ParameterMap& params) {
	ParameterMap::const_iterator it;
	bool                         bInitSuccess = true;

	if ((it = params.find("seed")) != params.end()) {
		srand( ParameterMap::mapped_type(it->second).longValue() );
	}
	// here is an example how you should access your parameters value from
	// the map
	/*
	if ((it = params.find("MYPARAM")) != params.end()) {
		myparam = ParameterMap::mapped_type(it->second);
	}
	else {
		bInitSuccess = false;
		opp_warning("No MYPARAM defined in config.xml for ${amName}!");
	}
	*/<#if par1Name!="">
	if ((it = params.find("${par1Name}")) != params.end()) {
		${par1Name} = ParameterMap::mapped_type(it->second).${par1Type}Value();
	}
	else {
		bInitSuccess = false;
		opp_warning("No ${par1Name} defined in config.xml for ${amName}!");
	}</#if><#if par2Name!="">
	if ((it = params.find("${par2Name}")) != params.end()) {
		${par2Name} = ParameterMap::mapped_type(it->second).${par2Type}Value();
	}
	else {
		bInitSuccess = false;
		opp_warning("No ${par2Name} defined in config.xml for ${amName}!");
	}</#if>
	
	return AnalogueModel::initFromMap(params) && bInitSuccess;
}

void ${amName}::filterSignal(airframe_ptr_t frame, const Coord& sendersPos, const Coord& receiverPos)
{
	Signal&   signal = frame->getSignal();
	simtime_t start  = signal.getReceptionStart();
	simtime_t end    = signal.getReceptionEnd();
	ev << "Filtering a signal from " << start << " to " << end << "." << endl;

	//create an appropriate mapping to represent our attenuation
	Mapping* attenuation = MappingUtils::createMapping();

	//define the attenuation (as a gain factor) in the mapping (in this case no attenuation)
	attenuation->setValue(Argument(start), 1);
	//TODO: write your own attenuation to the mapping

	//add attenuation to the signals attenuation list
	//this makes our attenuation affect the signal
	signal.addAttenuation(attenuation);
}

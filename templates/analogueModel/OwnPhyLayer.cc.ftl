<@setoutput path="${phyName}.cc" />
${bannerComment}

#include "${phyName}.h"
#include "${amName}.h"

Define_Module(${phyName});

AnalogueModel* ${phyName}::getAnalogueModelFromName(const std::string& name, ParameterMap& params) const {

	if (name == "${amName}") {
		return createAnalogueModel<${amName}>(params);
	}
	return PhyLayer::getAnalogueModelFromName(name, params);
}

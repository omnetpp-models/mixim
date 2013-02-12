<@setoutput path="${phyName}.h" />
${bannerComment}

#ifndef ${(phyName?upper_case)}_H_
#define ${(phyName?upper_case)}_H_

#include <PhyLayer.h>

class ${phyName} : public PhyLayer {
public:
	/**
	 * @brief Creates and returns an instance of the AnalogueModel with the
	 * specified name.
	 *
	 * Is able to initialize the following AnalogueModels:
	 * - ${amName}
	 */
	virtual AnalogueModel* getAnalogueModelFromName(const std::string& name, ParameterMap& params) const;

};

#endif /* ${(phyName?upper_case)}_H_ */

#ifndef TESTPHYLAYER_H_
#define TESTPHYLAYER_H_

#include <PhyLayer.h>
#include <string>

/**
 * @brief Simple PhyLayer sub class which is just responsible for
 * creating and initialising its own AnalogueModels and Decider.
 *
 * Initializing own AnalogueModels or Decider is the only task a PhyLayer-
 * subclass will normally have to do. Everything else should be already
 * done by the PhyLayer or should be implemented by writing your own
 * Decider or AnalogueModels.
 *
 * @ingroup phyLayer
 * @ingroup exampleAM
 */
class SamplePhyLayer:public PhyLayer{
protected:

	/**
	 * @brief Creates and returns an instance of the AnalogueModel with the
	 *        specified name.
	 *
	 * Is able to initialize the following AnalogueModels:
	 * - RandomFreqTimeModel
	 * - RandomFrequencyOnlyModel
	 */
	virtual AnalogueModel* getAnalogueModelFromName( const std::string& name
	                                               , ParameterMap&      params) const;

	/**
	 * @brief This method is called by the PhyLayer to initialize
	 *        the decider read from the config.xml.
	 *
	 * Every decider which should be usable by a Simulation using this
	 * class has to be known by either this method or (one of) the
	 * base methods.
	 *
	 * Is able to initialize directly the following decider:
	 * - ThresholdDecider
	 */
	virtual Decider* getDeciderFromName(const std::string& name, ParameterMap& params);

	void log(std::string msg) const;

	/**
	 * Converts the passed value to a string. There has to be
	 * an implementation of the << operator for the type of the
	 * variable and std::ostream:
	 *
	 * std::ostream& operator<<(std::ostream& o, const T& v)
	 */
	template<class T> std::string toString(const T& v) const {
		std::ostringstream o;
		o << v;
		return o.str();
	};

public:
	SamplePhyLayer()
		: PhyLayer()
	{}
	virtual void initialize(int stage);

	/**
	 * @brief Normally a sub-classed phy-layer doesn't has to implement
	 * this method. We are only doing this to display some messages
	 * telling the current state.
	 *
	 * Note: IF a subclass overrides this method it should make sure to
	 * call the base method.
	 */
	virtual void handleMessage(cMessage* msg);
};

#endif /*TESTPHYLAYER_H_*/

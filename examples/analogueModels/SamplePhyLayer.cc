#include "SamplePhyLayer.h"

#include "ThresholdDecider.h"
#include "RandomFreqTimeModel.h"
#include "RandomFrequencyOnlyModel.h"

Define_Module(SamplePhyLayer);


void SamplePhyLayer::initialize(int stage) {
	//call BasePhy's initialize
	PhyLayer::initialize(stage);

	if(stage == 0) {
	} else if(stage == 1) {
		//Decider and AnalogueModels are created by the PhyLayer in this stage
	}
}

void SamplePhyLayer::handleMessage(cMessage* msg) {
	if(msg->getKind() == AIR_FRAME) {
		airframe_ptr_t frame = static_cast<airframe_ptr_t>(msg);

		//normally a subclassed phylayer doesn't has to care about these
		//events, we only catch them to display some messages telling the
		//current state of the receiving process
		switch(frame->getState()) {
		case START_RECEIVE:
			if(frame->getSignal().getReceptionStart() != simTime())
				log("Received delayed AirFrame (state=START_RECEIVE). Proceeding it directly to RECEIVING state");
			else
				log("Received AirFrame (state=START_RECEIVE). Proceeding it directly to RECEIVING state");
			break;

		case RECEIVING:
			log("Received scheduled AirFrame for further processing through the decider.");
			break;

		case END_RECEIVE:
			log("Last receive of scheduled AirFrame because AirFrame transmission is over. (state=END_RECEIVE");
			break;

		default:
			break;
		}
	}

	//IF a subclass of PhyLayer overrides the handleMessage method it should
	//make sure to call the base method.
	PhyLayer::handleMessage(msg);
}

void SamplePhyLayer::log(std::string msg) const {
	ev << "[Host " << findHost()->getIndex() << "] - PhyLayer: " << msg << endl;
}

AnalogueModel* SamplePhyLayer::getAnalogueModelFromName(const std::string& name, ParameterMap& params) const {

	if(name == "RandomFreqTimeModel")
		return createAnalogueModel<RandomFreqTimeModel>(params);
	if(name == "RandomFrequencyOnlyModel")
		return createAnalogueModel<RandomFrequencyOnlyModel>(params);

	//If we couldn't create the passed analogue model, call the method
	//of our base class.
	//Note: even if all models defined in the xml-config can be handled
	//by this class method, there will be at least the call to create
	//the RadioStateAnalogueModel which in almost every case has to be done
	//by the PhyLayer.
	return PhyLayer::getAnalogueModelFromName(name, params);
}

Decider* SamplePhyLayer::getDeciderFromName(const std::string& name, ParameterMap& params) {

	if(name == "ThresholdDecider"){
	    return createDecider<ThresholdDecider>(params);
	}

	return PhyLayer::getDeciderFromName(name, params);
}

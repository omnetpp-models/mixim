#ifndef TESTGLOBALS_H_
#define TESTGLOBALS_H_

#include <TestModule.h>
#include <MiximAirFrame_m.h>

enum {
	TEST_MACPKT = 12121
};

class AssertAirFrame:public AssertMessage {
private:
	/** @brief Copy constructor is not allowed.
	 */
	AssertAirFrame(const AssertAirFrame&);
	/** @brief Assignment operator is not allowed.
	 */
	AssertAirFrame& operator=(const AssertAirFrame&);

protected:	
	MiximAirFrame* pointer;
	simtime_t arrival;
	int state;
public:
	AssertAirFrame(	std::string msg, int state,
					simtime_t arrival,
					MiximAirFrame* frame = 0,
					bool continuesTests = false)
		: AssertMessage(msg, false, continuesTests)
		, pointer(frame)
		, arrival(arrival)
		, state(state)
	{}
	
	virtual ~AssertAirFrame() {}
		
	/**
	 * Returns true if the passed message is the message
	 * expected by this AssertMessage.
	 * Has to be implemented by every subclass.
	 */
	virtual bool isMessage(cMessage* msg) {
		MiximAirFrame* frame = dynamic_cast<MiximAirFrame*>(msg);
		return frame != 0 && (frame == pointer || pointer == 0) && arrival == msg->getArrivalTime() &&frame->getState() == state;
	}
};

#endif /*TESTGLOBALS_H_*/

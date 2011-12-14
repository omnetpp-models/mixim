package org.mixim.tests.connectionManager;

import org.mixim.tests.TestObject;

// Common phy layer test interface.
moduleinterface ITestPhyLayer
{
    parameters:
        bool usePropagationDelay; //Should transmission delay be simulated?
    gates:
        input radioIn; // for sendDirect
}

// Physical layer test object which broadcasts packets and expects at least
// one answer.
simple ConnectedBCNodePhyLayer extends TestObject like ITestPhyLayer
{
    parameters:
        @class(ConnectedBCNodePhyLayer);
        bool usePropagationDelay = false; // no transmission delay
    gates:
        input radioIn; // for sendDirect
}

// Physical layer test object which broadcasts packets and expects no answer
// (bacause of missing connectivity).
simple NotConnectedBCNodePhyLayer extends TestObject like ITestPhyLayer
{
    parameters:
        @class(NotConnectedBCNodePhyLayer);
        bool usePropagationDelay = false; // no transmission delay
    gates:
        input radioIn; // for sendDirect
}

// Physical layer test object which expects to receive and answers at
// least one broadcast.
simple ConnectedRNodePhyLayer extends TestObject like ITestPhyLayer
{
    parameters:
        @class(ConnectedRNodePhyLayer);
        bool usePropagationDelay = false; // no transmission delay
    gates:
        input radioIn; // for sendDirect
}

// Physical layer test object which expects not to receive
// broadcasts (bacause of missing connectivity).
simple NotConnectedRNodePhyLayer extends TestObject like ITestPhyLayer
{
    parameters:
        @class(NotConnectedRNodePhyLayer);
        bool usePropagationDelay = false; // no transmission delay
    gates:
        input radioIn; // for sendDirect
}


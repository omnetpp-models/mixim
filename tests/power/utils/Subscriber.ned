//# Energy Framework for Omnet++, version 0.9
//#
//# Author:  Laura Marie Feeney 
//# 
//# Copyright 2009 Swedish Institute of Computer Science.  
//# 
//# This software is provided `as is' and without any express or implied
//# warranties, including, but not limited to, the implied warranties of
//# merchantability and fitness for a particular purpose.
//#
//######################################################################
package org.mixim.tests.power.utils;

import org.mixim.tests.TestObject;

// test module only (subscribes to and records Host failure notifications)
//
// note that all modules that generate msgs should cancel them in
// response to host failure
simple Subscriber extends TestObject
{
    parameters:
        @class(Subscriber);
        bool debug = default(false);
}

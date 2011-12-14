//***************************************************************************
//* file:        CSMA802154.ned
//*
//* author:      Jerome Rousselot, Marc Loebbers
//* 
//* copyright:   (C) 2007-2009 CSEM SA, Neuchatel, Switzerland.
//*		 		 (C) 2004 Telecommunication Networks Group (TKN) at
//*              Technische Universitaet Berlin, Germany.
//*
//*              This program is free software; you can redistribute it
//*              and/or modify it under the terms of the GNU General Public
//*              License as published by the Free Software Foundation; either
//*              version 2 of the License, or (at your option) any later
//*              version.
//*              For further information see file COPYING
//*              in the top level directory
//*
//* Funding: This work was partially financed by the European Commission under the  
//* Framework 6 IST Project "Wirelessly Accessible Sensor Populations"  
//* (WASP) under contract IST-034963.
//***************************************************************************
//* part of:    Modifications to the MF-2 framework by CSEM
//**************************************************************************/
package org.mixim.modules.mac;

//
// IEEE 802.15.4-2006 non-beacon enabled CSMA protocol
// This model was independently validated on a wireless sensor network testbed.
// For more information, see 
// Accurate Timeliness Simulations for Real-Time Wireless Sensor Networks,
// J. Rousselot, J.-D. Decotignie, M. Aoun, P. van der Stok, R. Serna Oliver,
// G. Fohler. In Proceedings of the 2009 Third UKSim European Symposium on Computer 
// Modeling and Simulation. 
//
// http://dx.doi.org/10.1109/EMS.2009.34
// 
simple CSMA802154 extends csma
{
    parameters:
        @class(CSMA802154);
        
        headerLength @unit(bit) = default(72 bit);
        macMaxCSMABackoffs = default(4);  // takes values between 0 and 5  
        //txPower @unit(mW);
        useMACAcks = default(true);
        
        backoffMethod = "exponential";
        macMaxBE = default(5);	// takes values between 3 and 8
        macMinBE = default(3);	// takes values between 0 and macMaxBE
}

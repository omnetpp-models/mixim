//***************************************************************************
// * file:        Network.ned
// *
// * author:      Marc Loebbers
// *
// * copyright:   (C) 2004 Telecommunication Networks Group (TKN) at
// *              Technische Universitaet Berlin, Germany.
// *
// *              This program is free software; you can redistribute it 
// *              and/or modify it under the terms of the GNU General Public 
// *              License as published by the Free Software Foundation; either
// *              version 2 of the License, or (at your option) any later 
// *              version.
// *              For further information see file COPYING 
// *              in the top level directory
// ***************************************************************************
// * part of:     framework implementation developed by tkn
// * description: a network to test the 802.11 modules
// *              
// ***************************************************************************
// * changelog:   $Revision: 103 $
// *              last modified:   $Date: 2004-09-23 09:56:00 +0200 (Do, 23 Sep 2004) $
// *              by:              $Author: omfw-willkomm $
// **************************************************************************/
package org.mixim.tests.power.Nic80211Test;

import org.mixim.base.modules.BaseNetwork;

network Nic80211PowerTest extends BaseNetwork
{
    parameters:
        // parametes for the framework
        playgroundSizeX = default(40m);
        playgroundSizeY = default(40m);
        playgroundSizeZ = default(40m);
        int numHosts = default(2);

    submodules:
        host[numHosts]: Nic80211TestHost {
            parameters:
                
                @display("p=141,112;i=misc/node");

        }
    connections allowunconnected:
    // all connections and gates are to be generated dynamically

}

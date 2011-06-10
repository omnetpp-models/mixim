package org.mixim.base.modules;

import inet.mobility.IMobility;


module BaseObject
{
    parameters:
        @display("bgb=180,200,white,,;bgp=10,10");
    submodules:
        utility: BaseUtility {
            parameters:
                @display("p=130,38,rect;b=24,24,,black,,");
        }
        mobility: <> like IMobility {
            parameters:
                @display("p=130,172;i=cogwheel2");

        }
}


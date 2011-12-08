<#if wizardType!="simplemodule">
<@setoutput path="${amName}TestNetwork.ned" />
${bannerComment}

<#if nedPackageName!="">package ${nedPackageName};</#if>

import org.mixim.base.modules.BaseNetwork;

network ${amName}TestNetwork extends BaseNetwork
{
    parameters:
        int numNodes; // total number of hosts in the network

    submodules:
        node[numNodes]: ${amName}TestNode {
            parameters:
                @display("p=170,50;i=device/wifilaptop");
        }
    connections allowunconnected:
    // all connections and gates are to be generated dynamically
}
</#if>

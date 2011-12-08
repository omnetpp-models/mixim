
<@setoutput path=targetMainFile />
${bannerComment}

<#if nedPackageName!="">package ${nedPackageName};</#if>

<#if protocolName=="802.11">
<#assign hostType="Host80211">
import org.mixim.modules.node.${hostType};
<#elseif protocolName=="B-MAC">
<#assign hostType="HostBMAC">
import org.mixim.modules.node.${hostType};
<#elseif protocolName=="L-MAC">
<#assign hostType="HostLMAC">
import org.mixim.modules.node.${hostType};
<#elseif protocolName=="CSMA 802.15.4">
<#assign hostType="Host802154">
<#else>
<#assign hostType="HostBasic">
import org.mixim.modules.node.${hostType};
</#if>

import org.mixim.base.modules.BaseNetwork;

network ${targetTypeName} extends BaseNetwork
{
    parameters:
        int numNodes; // total number of hosts in the network

    submodules:
        node[numNodes]: ${hostType} {}
    connections allowunconnected:
    // all connections and gates are to be generated dynamically
}

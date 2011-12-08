<#if wizardType!="simplemodule">
<@setoutput path="${amName}TestNode.ned" />
${bannerComment}

<#if nedPackageName!="">package ${nedPackageName};</#if>

import org.mixim.modules.node.WirelessNode;

module ${amName}TestNode extends WirelessNode
{
    parameters:
        nicType = "${nedPackageName}.${amName}TestNic";
}
</#if>

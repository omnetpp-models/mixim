<#if wizardType!="simplemodule">
<@setoutput path="${amName}TestNic.ned" />
${bannerComment}

<#if nedPackageName!="">package ${nedPackageName};</#if>

import org.mixim.modules.nic.WirelessNic;

module ${amName}TestNic extends WirelessNic
{
    parameters:
        @display("i=block/ifcard");
        phyType = "${nedPackageName}.${phyName}";
}
</#if>

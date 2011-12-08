<#if protocolName=="CSMA using old CSMAMacLayer">
<#if nedPackageName!="">package ${nedPackageName};</#if>

import org.mixim.modules.nic.WirelessNicBattery;

module CSMANic extends WirelessNicBattery
{
    parameters:
        macType = "CSMAMacLayer";
}
</#if>

<#if wizardType!="simplemodule">
[General]
network = ${amName}TestNetwork


##########################################################
#			Simulation parameters                        #
##########################################################
**.**.coreDebug = false
**.playgroundSizeX = 300m
**.playgroundSizeY = 300m
**.playgroundSizeZ = 300m
**.numNodes = 2

##########################################################
#			WorldUtility parameters                      #
##########################################################
**.world.useTorus = false
**.world.use2D = false

##########################################################
#			         channel parameters                  #
##########################################################
**.connectionManager.sendDirect = false
**.connectionManager.pMax = 100mW
**.connectionManager.sat = -84dBm
**.connectionManager.alpha = 3.0
**.connectionManager.carrierFrequency = 2.412e+9Hz


################ PhyLayer parameters #####################
**.node[*].nic.phy.usePropagationDelay = false
**.node[*].nic.phy.thermalNoise = -100dBm
**.node[*].nic.phy.useThermalNoise = true
        
**.node[*].nic.phy.analogueModels = xmldoc("config-template.xml")
**.node[*].nic.phy.decider = xmldoc("deciderConfig.xml")

**.node[*].nic.phy.sensitivity = -80dBm
**.node[*].nic.phy.maxTXPower = 100.0mW

**.node[*].nic.phy.initialRadioState = 0

################ MAC layer parameters ####################
**.node[*].nic.mac.queueLength = 5
**.node[*].nic.mac.headerLength = 24bit
**.node[*].nic.mac.slotDuration = 0.04s
**.node[*].nic.mac.difs = 0.0005s
**.node[*].nic.mac.maxTxAttempts = 14
**.node[*].nic.mac.defaultChannel = 0
**.node[*].nic.mac.bitrate = 15360bps
**.node[*].nic.mac.contentionWindow = 20
**.node[*].nic.mac.txPower = 100mW  # [mW]

################ NETW layer parameters ####################

################ Mobility parameters #####################
**.node[*].mobility.initialZ = 0m

**.node[0].mobility.initialX = 150m
**.node[0].mobility.initialY = 150m

**.node[1].mobility.initialX = 250m
**.node[1].mobility.initialY = 150m


**.node[*].applicationType = "BurstApplLayer"
**.node[*].appl.debug = false
**.node[*].appl.headerLength = 512bit
**.node[*].appl.burstSize = 3

**.node[*].networkType = "BaseNetwLayer"
**.node[*].netwl.debug = false
**.node[*].netwl.stats = false
**.node[*].netwl.headerLength = 32bit

</#if>
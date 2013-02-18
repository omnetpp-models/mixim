# location of INET project relative to the 'src' directory!
INET_PROJECT_DIR=../../inet

all: checkmakefiles
	cd src && $(MAKE)
	cd examples && $(MAKE)

tests: all
	cd tests && $(MAKE)

clean: checkmakefiles
	cd src && $(MAKE) clean
	cd examples && $(MAKE) clean
	cd tests && $(MAKE) clean

cleanall: checkmakefiles
	cd src && $(MAKE) clean
	cd tests && $(MAKE) clean
	cd examples && $(MAKE) clean
	rm -f src/Makefile
	rm -f examples/Makefile
	rm -f tests/Makefile
	rm -rf out/

makefiles:
	cd src && opp_makemake -f --deep --make-so -o mixim -O out -I$$\(INET_PROJ\)/src/linklayer/ethernet -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio -I$$\(INET_PROJ\)/src/networklayer/common -I$$\(INET_PROJ\)/src/networklayer/icmpv6 -I$$\(INET_PROJ\)/src -I$$\(INET_PROJ\)/src/world/obstacles -I$$\(INET_PROJ\)/src/mobility/models -I$$\(INET_PROJ\)/src/networklayer/xmipv6 -I$$\(INET_PROJ\)/src/mobility -I$$\(INET_PROJ\)/src/networklayer/contract -I$$\(INET_PROJ\)/src/networklayer/manetrouting/base -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mgmt -I$$\(INET_PROJ\)/src/util -I$$\(INET_PROJ\)/src/transport/contract -I$$\(INET_PROJ\)/src/linklayer/radio/propagation -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio/errormodel -I$$\(INET_PROJ\)/src/world/powercontrol -I$$\(INET_PROJ\)/src/linklayer/radio -I$$\(INET_PROJ\)/src/util/headerserializers/tcp -I$$\(INET_PROJ\)/src/networklayer/ipv4 -I$$\(INET_PROJ\)/src/util/headerserializers/ipv4 -I$$\(INET_PROJ\)/src/base -I$$\(INET_PROJ\)/src/util/headerserializers -I$$\(INET_PROJ\)/src/world/radio -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mac -I$$\(INET_PROJ\)/src/networklayer/ipv6 -I$$\(INET_PROJ\)/src/transport/sctp -I$$\(INET_PROJ\)/src/util/headerserializers/udp -I$$\(INET_PROJ\)/src/networklayer/ipv6tunneling -I$$\(INET_PROJ\)/src/battery/models -I$$\(INET_PROJ\)/src/applications/pingapp -I$$\(INET_PROJ\)/src/linklayer/contract -I$$\(INET_PROJ\)/src/util/headerserializers/sctp -I$$\(INET_PROJ\)/src/transport/tcp_common -I$$\(INET_PROJ\)/src/networklayer/arp -I$$\(INET_PROJ\)/src/transport/udp -L$$\(INET_PROJ\)/out/$$\(CONFIGNAME\)/src -linet -DWITH_MIXIM_EXAMPLES -DMIXIM_INET -DINET_IMPORT -KINET_PROJ=$(INET_PROJECT_DIR)
	cd examples && opp_makemake -f --deep -o miximexamples -O out -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio -I$$\(INET_PROJ\)/src/linklayer/ethernet -I$$\(INET_PROJ\)/src/networklayer/common -I../src/modules/phy -I$$\(INET_PROJ\)/src -I$$\(INET_PROJ\)/src/networklayer/icmpv6 -I$$\(INET_PROJ\)/src/world/obstacles -I$$\(INET_PROJ\)/src/networklayer/xmipv6 -I$$\(INET_PROJ\)/src/networklayer/manetrouting/base -I$$\(INET_PROJ\)/src/mobility -I$$\(INET_PROJ\)/src/mobility/models -I$$\(INET_PROJ\)/src/networklayer/contract -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mgmt -I../src/base/connectionManager -I$$\(INET_PROJ\)/src/util -I$$\(INET_PROJ\)/src/transport/contract -I$$\(INET_PROJ\)/src/linklayer/radio/propagation -I../src/base/phyLayer -I../src/base/modules -I../src/base/utils -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio/errormodel -I$$\(INET_PROJ\)/src/linklayer/radio -I$$\(INET_PROJ\)/src/world/powercontrol -I$$\(INET_PROJ\)/src/util/headerserializers/tcp -I$$\(INET_PROJ\)/src/networklayer/ipv4 -I../src/base/messages -I../src/modules/utility -I$$\(INET_PROJ\)/src/util/headerserializers/ipv4 -I$$\(INET_PROJ\)/src/base -I../src/base -I$$\(INET_PROJ\)/src/util/headerserializers -I$$\(INET_PROJ\)/src/world/radio -I../src/modules/analogueModel -I../src/modules/messages -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mac -I$$\(INET_PROJ\)/src/networklayer/ipv6 -I$$\(INET_PROJ\)/src/transport/sctp -I$$\(INET_PROJ\)/src/util/headerserializers/udp -I$$\(INET_PROJ\)/src/networklayer/ipv6tunneling -I$$\(INET_PROJ\)/src/applications/pingapp -I$$\(INET_PROJ\)/src/battery/models -I$$\(INET_PROJ\)/src/util/headerserializers/sctp -I$$\(INET_PROJ\)/src/linklayer/contract -I$$\(INET_PROJ\)/src/networklayer/arp -I$$\(INET_PROJ\)/src/transport/tcp_common -I$$\(INET_PROJ\)/src/transport/udp -L$$\(INET_PROJ\)/out/$$\(CONFIGNAME\)/src -L../out/$$\(CONFIGNAME\)/src -lmixim -linet -DWITH_MIXIM_EXAMPLES -DMIXIM_INET -DINET_IMPORT -KINET_PROJ=$(INET_PROJECT_DIR)
	cd tests && opp_makemake -f --deep -o miximtests -O out -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio -I$$\(INET_PROJ\)/src/linklayer/ethernet -I$$\(INET_PROJ\)/src/networklayer/common -I../src/modules/phy -I$$\(INET_PROJ\)/src -I$$\(INET_PROJ\)/src/networklayer/icmpv6 -I$$\(INET_PROJ\)/src/world/obstacles -I$$\(INET_PROJ\)/src/networklayer/xmipv6 -I$$\(INET_PROJ\)/src/networklayer/manetrouting/base -I$$\(INET_PROJ\)/src/networklayer/contract -I$$\(INET_PROJ\)/src/mobility -I$$\(INET_PROJ\)/src/mobility/models -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mgmt -I../src/base/connectionManager -I$$\(INET_PROJ\)/src/util -I$$\(INET_PROJ\)/src/transport/contract -I$$\(INET_PROJ\)/src/linklayer/radio/propagation -I../src/base/phyLayer -I../src/base/modules -I../src/base/utils -I$$\(INET_PROJ\)/src/linklayer/ieee80211/radio/errormodel -I$$\(INET_PROJ\)/src/linklayer/radio -I$$\(INET_PROJ\)/src/world/powercontrol -I$$\(INET_PROJ\)/src/util/headerserializers/tcp -I$$\(INET_PROJ\)/src/networklayer/ipv4 -I../src/base/messages -I../src/modules/utility -I$$\(INET_PROJ\)/src/util/headerserializers/ipv4 -I$$\(INET_PROJ\)/src/base -I../src/base -I$$\(INET_PROJ\)/src/util/headerserializers -I$$\(INET_PROJ\)/src/world/radio -I../src/modules/analogueModel -I../src/modules/messages -I$$\(INET_PROJ\)/src/linklayer/ieee80211/mac -I$$\(INET_PROJ\)/src/networklayer/ipv6 -I$$\(INET_PROJ\)/src/transport/sctp -I$$\(INET_PROJ\)/src/util/headerserializers/udp -I$$\(INET_PROJ\)/src/networklayer/ipv6tunneling -I$$\(INET_PROJ\)/src/applications/pingapp -I$$\(INET_PROJ\)/src/battery/models -I$$\(INET_PROJ\)/src/util/headerserializers/sctp -I$$\(INET_PROJ\)/src/linklayer/contract -I$$\(INET_PROJ\)/src/networklayer/arp -I$$\(INET_PROJ\)/src/transport/tcp_common -I$$\(INET_PROJ\)/src/transport/udp -I../src/modules/power/battery -I../src/modules/mac -L$$\(INET_PROJ\)/out/$$\(CONFIGNAME\)/src -L../out/$$\(CONFIGNAME\)/src -lmixim -linet -DWITH_MIXIM_EXAMPLES -DMIXIM_INET -DINET_IMPORT -KINET_PROJ=$(INET_PROJECT_DIR)

checkmakefiles:
	@if [ ! -f src/Makefile ]; then \
	echo; \
	echo '======================================================================='; \
	echo 'src/Makefile does not exist. Please use "make makefiles" to generate it!'; \
	echo '======================================================================='; \
	echo; \
	exit 1; \
	fi

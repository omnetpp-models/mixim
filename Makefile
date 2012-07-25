all: checkmakefiles
	cd src && $(MAKE)
	cd examples && $(MAKE)
	cd tests && $(MAKE)

clean: checkmakefiles
	cd src && $(MAKE) clean
	cd examples && $(MAKE) clean
	cd tests && $(MAKE) clean

cleanall: checkmakefiles
	cd src && $(MAKE) MODE=release clean
	cd src && $(MAKE) MODE=debug clean
	rm -f src/Makefile
	rm -f examples/Makefile
	rm -f tests/Makefile
	rm -rf out/

makefiles:
	cd src && opp_makemake -f --deep
	cd examples && opp_makemake -f --deep
	cd tests && opp_makemake -f --deep

checkmakefiles:
	@if [ ! -f src/Makefile ]; then \
	echo; \
	echo '======================================================================='; \
	echo 'src/Makefile does not exist. Please use "make makefiles" to generate it!'; \
	echo '======================================================================='; \
	echo; \
	exit 1; \
	fi

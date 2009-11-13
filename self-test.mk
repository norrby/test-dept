GCC=gcc

feature-test:
	$(MAKE) -C examples check

self-test:
	env PATH=$$PATH:../src $(MAKE) CC=$(GCC) LD=$(GCC) -C test -I../src self_test

check:	self-test feature-test
	echo "Both basic low level tests and feature self tests passed!"

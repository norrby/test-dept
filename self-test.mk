BINPATH_BASE=env PATH=$$PATH:..

self-test:
	$(BINPATH_BASE)/src $(MAKE) CC=$(GCC) LD=$(GCC) -C test -I../src self_test

GCC=gcc
EXAMPLE_PROJECTS=automatic_project example_project off_dir simple_project
EXAMPLES=$(addprefix examples/,$(EXAMPLE_PROJECTS))

$(EXAMPLES):
	$(BINPATH_BASE)/../src $(MAKE) -C $@ -I../../src test_dept

feature-test: $(EXAMPLES)
	src/test_dept $(addsuffix /*_test,$^)

check:	self-test feature-test

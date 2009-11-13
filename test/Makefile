# If this Makefile can run a couple of assertion tests that all
# pass the testing framework is quite healthy on a basic level.

TEST_SRCS=assertion_test.c prepost_test.c
CPPFLAGS=-I../src

build_self_test:	test_dept
self_test:	test_dept_run

clean:
	rm -f $(TEST_MAINS) *.o

include test-dept-rudimentary.mk

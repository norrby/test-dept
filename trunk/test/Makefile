CC=gcc
LD=$(CC)

TEST_SRCS=assertion_test.c prepost_test.c
CPPFLAGS=-I ../src

#Add a script test to the standard C test suite
test_dept_run:	build_main_test

sik_test: sut_sum.o sum_stubs.o

build_self_test:	test_dept
self_test:	test_dept_run

clean:
	rm -f $(TEST_MAINS) *.o

include test_dept_normal.mk

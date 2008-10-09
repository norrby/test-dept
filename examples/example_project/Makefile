# Copyright 2008 Mattias Norrby
#
# This file is part of Test Dept..
#
# Test Dept. is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Test Dept. is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Test Dept..  If not, see <http://www.gnu.org/licenses/>.

# An example project using test_dept in its default form

# Basic definitions for the project to be able to build
CC=gcc
LD=$(CC)

#You can remove these when an installation of Test Dept. is made on your system
TEST_DEPT_BIN_PATH=../../src
TEST_DEPT_INCLUDE_PATH=$(TEST_DEPT_BIN_PATH)
CPPFLAGS=-I$(TEST_DEPT_BIN_PATH)

# All test cases reside in TEST_SRCS.
TEST_SRCS=sum_test.c file_ops_test.c instruments_test.c another_sum_test.c

# A file which declares all possible stub functions
TEST_DEPT_POSSIBLE_STUBS=stubs.h
TEST_DEPT_GENERATED_STUB_HEADER=stub_headers.h

# Dependencies for each test binary. Should be self explanatory
# (If you do not want to specify the stubs dependencies, go for
# the simpler test_dept_simple.mk as the bottom include file.)
sum_test:	dependency.o sum_using_stubs.o sum_stubs.o 
file_ops_test:	file_ops_using_stubs.o file_ops_stubs.o
instruments_test: instruments_using_stubs.o instruments_stubs.o

# This kind of test case without a corresponding C file is only
# possible using the test_dept_normal.mk which is included in
# the current Makefile.
another_sum_test: sum.o dependency.o

check:	test_dept_run

clean:
	rm -f *.o *_test main_*.c *_stubs.* *~

# Rules for making test binaries reside here
include $(TEST_DEPT_INCLUDE_PATH)/test_dept_normal.mk

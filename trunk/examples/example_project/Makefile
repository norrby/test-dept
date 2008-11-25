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

# An example project using test_dept in its cstub form

# Basic definitions for the project to be able to build
CC=gcc
LD=$(CC)

#You can remove these when an installation of Test Dept. is made on your system
TEST_DEPT_BIN_PATH=../../src
TEST_DEPT_INCLUDE_PATH=$(TEST_DEPT_BIN_PATH)
CPPFLAGS=-I$(TEST_DEPT_BIN_PATH)

# All test cases reside in TEST_SRCS
TEST_SRCS=sum_test.c file_ops_test.c instruments_test.c another_sum_test.c

# A file which declares all possible stub functions
TEST_DEPT_POSSIBLE_STUBS=stubs.h
TEST_DEPT_FUNCTION_SWITCH_HEADER=stub_headers.h

# Dependencies for each test binary. Should be self explanatory
sum_test:	dependency.o

# A test case not corresponding to <prefix>_test.c needs an own rule
another_sum_test: sum.o dependency.o another_sum_test_main.o
	$(CC) $@.o $^ -o $@

check:	test_dept_run

clean:
	rm -f *.o *_test main_*.c *_stubs.* *~

# Rules for making test binaries reside here
include $(TEST_DEPT_INCLUDE_PATH)/test-dept-cstubs.mk

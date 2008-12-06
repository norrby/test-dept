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

# A simple test project with one C file as SUT. This project has
# no stubs, but it is easily added using the TEST_DEPT_POSSIBLE_STUBS
# variable pointing to a header file stating prototypes for stub
# functions.

CC=gcc
LD=$(CC)

#You can remove these when an installation of Test Dept. is made on your system
TEST_DEPT_BIN_PATH=../../src
TEST_DEPT_INCLUDE_PATH=$(TEST_DEPT_BIN_PATH)
CPPFLAGS=-I$(TEST_DEPT_INCLUDE_PATH) -Isrc

TEST_DEPT_SRC_DIR=src
TEST_SRCS=test/file1_test.c

all:	test_dept_run

clean:
	rm -f *.o *_test

include $(TEST_DEPT_INCLUDE_PATH)/test-dept.mk

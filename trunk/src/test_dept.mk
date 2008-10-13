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
#
# As a special exception, you may use this file as part of a free
# testing framework without restriction.  Specifically, if other files
# include this makefile for contructing test-cases this file does not
# by itself cause the resulting executable to be covered by the GNU
# General Public License.  This exception does not however invalidate
# any other reasons why the executable file might be covered by the
# GNU General Public License.

TEST_MAIN_SRCS=$(addprefix main_,$(TEST_SRCS))
TEST_MAIN_OBJS=$(patsubst %.c,%.o,$(TEST_MAIN_SRCS))
TEST_MAINS=$(patsubst main_%.o,%,$(TEST_MAIN_OBJS))

ifneq (,$(TEST_DEPT_BIN_PATH))
TEST_DEPT_RUNTIME_PREFIX=$(TEST_DEPT_BIN_PATH)/
endif

%_using_stubs.o: %_test.o %.o
	$(TEST_DEPT_RUNTIME_PREFIX)refer_to_stubs $^ $@

%_stubs.c: %_test.o $(TEST_DEPT_POSSIBLE_STUBS)
	$(TEST_DEPT_RUNTIME_PREFIX)build_stubs $^ >$@

$(TEST_DEPT_FUNCTION_SWITCH_HEADER): $(TEST_DEPT_POSSIBLE_STUBS)
	$(TEST_DEPT_RUNTIME_PREFIX)build_stub_headers $^ >$@

$(TEST_MAIN_OBJS): $(TEST_DEPT_FUNCTION_SWITCH_HEADER)

main_%.c:	%.c
	$(TEST_DEPT_RUNTIME_PREFIX)build_main $< $@

test_dept:	$(TEST_MAINS)

test_dept_run:	$(TEST_MAINS)
	$(TEST_DEPT_RUNTIME_PREFIX)test_dept $^

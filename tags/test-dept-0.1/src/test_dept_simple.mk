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

%_test:	%_test.o main_%_test.o %_using_stubs.o %_stubs.o
	$(LD) $^ -o $@

ifneq (,$(TEST_DEPT_INCLUDE_PATH))
TEST_DEPT_MAKEFILE_INCLUDE_PATH=$(TEST_DEPT_INCLUDE_PATH)/
endif
include $(TEST_DEPT_MAKEFILE_INCLUDE_PATH)test_dept.mk

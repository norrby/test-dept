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

PREFIX=/tmp/usr/local
INCLUDE_DIR=$(PREFIX)/includes
BIN_DIR=$(PREFIX)/bin
MAN_DIR=$(PREFIX)/man
SHARE_DIR=$(PREFIX)/share/test_dept

MAN_PAGES=test_dept.1
MANS=$(addprefix src,$(MAN_PAGES))
SRCS=src
SCRIPTS=build_stub build_stubs test_dept refer_to_stubs
INCLUDES=test_dept.mk test_dept_simple.mk test_dept_normal.mk test_dept.h
DOCS=README COPYING
SCRIPTS_INSTALLED=$(addprefix $(BIN_DIR)/,$(SCRIPTS))
INCLUDES_INSTALLED=$(addprefix $(INCLUDE_DIR)/,$(INCLUDES))
DOC_FILES_INSTALLED=$(addprefix $(SHARE_DIR)/,$(DOCS))

TEST_MAKEFILE=test/test.mk
SELF_TEST_CMD=/usr/bin/env PATH=../src:$(PATH) $(MAKE) -I ../src

build_example_projects:	self_test
	make -C examples/simple_project test_dept
	make -C examples/example_project test_dept

check:	build_example_projects
	find . -name '*_test' | xargs sh -eu src/test_dept

self_test:
	$(SELF_TEST_CMD) -C test build_self_test

test_clean:
	$(SELF_TEST_CMD) -C test clean

clean:	test_clean
	rm -f */*/*.o */*.o *.o examples/*/*_test

$(MAN_DIR) $(INCLUDE_DIR) $(SHARE_DIR) $(BIN_DIR):
	install -d $@

$(MAN_DIR)/%: $(SRCS)/% $(MAN_DIR)
	install -m 644 $< $(MAN_DIR)

$(INCLUDE_DIR)/%: $(SRCS)/% $(INCLUDE_DIR)
	install -m 644 $< $(INCLUDE_DIR) 

$(BIN_DIR)/%: $(SRCS)/% $(BIN_DIR)
	install $< $(BIN_DIR)

$(SHARE_DIR)/%: % $(SHARE_DIR)
	install -m 644 $< $(SHARE_DIR) 

install-man:	$(MAN_PAGES_INSTALLED)
install-doc:	$(DOC_FILES_INSTALLED)
install-script:	$(SCRIPTS_INSTALLED)
install-includes:	$(INCLUDES_INSTALLED)

install: install-man install-doc install-script install-includes

TEST_DEPT_EXEC_ARCH?=$(shell uname -m)
SYMBOLS_TO_ASM=$(TEST_DEPT_RUNTIME_PREFIX)sym2asm_$(TEST_DEPT_EXEC_ARCH).awk

%_using_proxies.o:	%.o
	$(TEST_DEPT_BIN_PATH)/repoint_sut $< $@

%_proxies.s: %.o
	$(TEST_DEPT_BIN_PATH)/build_asm_proxies $(SYMBOLS_TO_ASM) $< >$@

%_test_main.c: %_test.o
	 $(TEST_DEPT_BIN_PATH)/build_main_from_symbols $< >$@

%_test:	%_test_main.o %_test.o %_using_proxies.o sut_proxies.s
	$(CC) -o $@ $^

ifneq (,$(TEST_DEPT_INCLUDE_PATH))
TEST_DEPT_MAKEFILE_INCLUDE_PATH=$(TEST_DEPT_INCLUDE_PATH)/
endif
include $(TEST_DEPT_MAKEFILE_INCLUDE_PATH)test_dept.mk

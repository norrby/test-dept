/* sut_test.c */

#include <test-dept.h>
#include <sut.h>
#include <foo.h>
#include <stdio.h>
#include <stdlib.h>

void test_normal_fooify() {
  assert_not_equals(0, fooify(3));
}

void test_stringify() {
  char *h = stringify('h');
  assert_equals_string("h", h);
  free(h);
}

void *always_failing_malloc() {
  return NULL;
}

void test_stringify_cannot_malloc_returns_sane_result() {
  replace_function(&malloc, &always_failing_malloc);
  char *h = stringify('h');
  assert_equals_string("cannot_stringify", h);
}

int negative_foo(int value) {
  return -99 * value;
}

void test_broken_foo_makes_fooify_return_subzero() {
  replace_function(&foo, &negative_foo);
  assert_equals_int(-1, fooify(3));
}

void teardown() {
  restore_function(&malloc);
  restore_function(&foo);
}

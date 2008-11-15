#include <test_dept.h>

#include <foo.h>
#include <sut.h>
#include <bar.h>
#include <stdio.h>

int negative_foo(int value) {
  return -99 * value;
}

float static_bar(float value) {
  return 334 * value;
}

void test_normal_fooify() {
  assert_not_equals(0, fooify(3));
}

void test_broken_foo_makes_fooify_return_subzero() {
  replace_function(&foo, &negative_foo);
  assert_equals_int(-1, fooify(3));
}

void test_normal_barify() {
  assert_not_equals(0.3f, barify(3));
}

void test_broken_bar_makes_fooify_return_0_3() {
  replace_function(&bar, &static_bar);
  assert_equals_float(0.3f, barify(3));
}

void teardown() {
  restore_function(&foo);
  restore_function(&bar);
}

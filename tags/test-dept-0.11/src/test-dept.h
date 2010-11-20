/* Copyright 2008 Mattias Norrby
 * 
 * This file is part of Test Dept..
 * 
 * Test Dept. is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Test Dept. is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Test Dept..  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, you may use this file as part of a free
 * testing framework without restriction.  Specifically, if other
 * files use macros or inline functions from this file, or you compile
 * this file and link it with other files to produce an executable,
 * this file does not by itself cause the resulting executable to be
 * covered by the GNU General Public License.  This exception does not
 * however invalidate any other reasons why the executable file might
 * be covered by the GNU General Public License.
 */

#ifndef _TEST_DEPT_H_
#define _TEST_DEPT_H_

#include <stdio.h>
#include <string.h>
#include <assert.h>

#define _test_dept_assert_condition(condition, textual_condition) do {\
  test_dept_tests_run += 1;\
  if (!(condition)) {\
    test_dept_test_failures += 1;\
    fprintf(stderr, "%s:%d: Failure: expected that %s\n",\
            __FILE__, __LINE__, textual_condition);\
    return;\
  }\
} while(0)

#ifdef TEST_DEPT_USE_PREFIX
# define test_dept_assert_true _test_dept_assert_true
# define test_dept_assert_false _test_dept_assert_false
# define test_dept_assert_equals _test_dept_assert_equals
# define test_dept_assert_not_equals _test_dept_assert_not_equals
# define test_dept_assert_equals_int _test_dept_assert_equals_int
# define test_dept_assert_equals_hex _test_dept_assert_equals_hex
# define test_dept_assert_equals_short _test_dept_assert_equals_short
# define test_dept_assert_equals_long _test_dept_assert_equals_long
# define test_dept_assert_equals_char _test_dept_assert_equals_char
# define test_dept_assert_equals_float _test_dept_assert_equals_float
# define test_dept_assert_equals_double _test_dept_assert_equals_double
# define test_dept_assert_equals_string _test_dept_assert_equals_string
# define test_dept_replace_function _test_dept_replace_function
# define test_dept_restore_function _test_dept_restore_function
#else
# define assert_true _test_dept_assert_true
# define assert_false _test_dept_assert_false
# define assert_equals _test_dept_assert_equals
# define assert_not_equals _test_dept_assert_not_equals
# define assert_equals_int _test_dept_assert_equals_int
# define assert_equals_hex _test_dept_assert_equals_hex
# define assert_equals_short _test_dept_assert_equals_short
# define assert_equals_long _test_dept_assert_equals_long
# define assert_equals_char _test_dept_assert_equals_char
# define assert_equals_float _test_dept_assert_equals_float
# define assert_equals_double _test_dept_assert_equals_double
# define assert_equals_string _test_dept_assert_equals_string
# define replace_function _test_dept_replace_function
# define restore_function _test_dept_restore_function
#endif

#define _test_dept_assert_equals(a, b)\
 _test_dept_assert_condition((a) == (b), "(" # a ") == (" # b ")" )

#define _test_dept_assert_not_equals(a, b)\
 _test_dept_assert_condition((a) != (b), "(" # a ") != (" # b ")" )

#define _test_dept_assert_true(condition)	\
 _test_dept_assert_condition((condition), "(" # condition ")" )

#define _test_dept_assert_false(condition)\
 _test_dept_assert_condition(!(condition), "!(" # condition ")" )

#define _test_dept_assert_equals_type(type, format, exp, act) \
  do {\
  type actual = ( type ) (act);\
  char msg[64];\
  sprintf(msg, # act " == " # format " (was " # format ")", exp, actual);\
  _test_dept_assert_condition((actual) == (exp), msg);			      \
  } while (0)

#define _test_dept_assert_equals_int(exp, act)\
 _test_dept_assert_equals_type(int, %d, exp, act)

#define _test_dept_assert_equals_short(exp, act)\
 _test_dept_assert_equals_type(short, %d, exp, act)

#define _test_dept_assert_equals_long(exp, act)\
 _test_dept_assert_equals_type(long, %d, exp, act)

#define _test_dept_assert_equals_hex(exp, act)\
 _test_dept_assert_equals_type(long, 0x%x, exp, act);

#define _test_dept_assert_equals_char(exp, act)\
 _test_dept_assert_equals_type(char, %c, exp, act);

#define _test_dept_assert_equals_float(exp, act)\
 _test_dept_assert_equals_type(float, %f, exp, act);

#define _test_dept_assert_equals_double(exp, act)\
 _test_dept_assert_equals_type(double, %f, exp, act);

#define TEST_DEPT_MAX_COMPARISON 128
#define _test_dept_assert_equals_string(exp, act)\
  do {\
    char* actual = (act);\
    if (strlen(exp) > TEST_DEPT_MAX_COMPARISON\
        || strlen(actual) > TEST_DEPT_MAX_COMPARISON)\
     _test_dept_assert_false("strings too long to compare with this assertion");\
    char msg[1024];\
    sprintf(msg, "%s equals \"%s\" (was \"%s\")", # act, exp, actual);\
    _test_dept_assert_condition(strcmp(exp, actual) == 0, msg);\
  } while (0)

void **test_dept_proxy_ptrs[2];

static void
_test_dept_set_proxy(void *original_function, void *replacement_function)
{
  int i;
  for (i = 0; test_dept_proxy_ptrs[i] != NULL; i++) {
      if (*(test_dept_proxy_ptrs[i] + 1) == original_function) {
	  if (replacement_function)
	    *test_dept_proxy_ptrs[i] = replacement_function;
	  else
	    *test_dept_proxy_ptrs[i] = *(test_dept_proxy_ptrs[i] + 1);
	  return;
	}
    }
  printf("Warning, unable to set proxy for function %p, not found\n",
	 original_function);
}

#ifdef __GNUC__
#define _test_dept_replace_function(original_function, replacement_function)\
{\
  assert (replacement_function == NULL ||\
          __builtin_types_compatible_p(typeof(original_function),\
                                       typeof(replacement_function)));\
  _test_dept_set_proxy(original_function, replacement_function);\
}
#else
#define _test_dept_replace_function(original_function, replacement_function)\
{\
  _test_dept_set_proxy(original_function, replacement_function);\
}
#endif

static void _test_dept_restore_function(void *original_function) {
  _test_dept_set_proxy(original_function, NULL);
}

int test_dept_tests_run;
int test_dept_test_failures;

#endif

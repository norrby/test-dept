![http://test-dept.googlecode.com/svn/trunk/doc/art/logo.png](http://test-dept.googlecode.com/svn/trunk/doc/art/logo.png)

# Introduction #
Test Dept. is a testing framework for C with stubbing capabilities.
This is an introduction to testing, suites and usage. For deeper
behind-the-scenes information, please refer to the [How It Works](TestAutomation.md)
page.

The goals of the Test Dept. framework for unit-testing are to:

  * Be usable for pure C-projects
  * Support stubs for C (or at least replaceable functions)
  * Be compatible with different test runners
  * Encourage independent test cases
  * Strive for TestAutomation

In practice, these goals are (somewhat) reached by:

  * A macro-based assertion suite for C
  * Makefile snippets for replacing symbols in SUT for stubbing
  * Standardizing the observable test suite behavior
  * Using runnable binaries as suites - one binary per suite

These concepts are all described later in this README. For everything
to work properly there are some prerequisites:

  * It needs GNU make(1) version 3.81 or later for building suites.
  * It uses objcopy(1), objdump(2) and nm(1) for stubbing.
  * It depends on the LINE and FILE macros of gcc(1) for assertions.
  * It uses awk(1) and sed(1) for some textfile processing.

Both nm(1) and objcopy(1) are often parts of a "binutils" package.

# The Suite Concept #
A test suite contains one or more test cases.  A test runner can run
several test suites in succession.

![http://test-dept.googlecode.com/svn/trunk/doc/art/suites.png](http://test-dept.googlecode.com/svn/trunk/doc/art/suites.png)

As stated above one or more test cases comprise such a test suite:

![http://test-dept.googlecode.com/svn/trunk/doc/art/cases.png](http://test-dept.googlecode.com/svn/trunk/doc/art/cases.png)

In its basic form the contained cases are run one at a time.  Each
test case execution is spawned by running a suite binary while
specifying a case to run.  For example:
```
> ./my_test_suite name_of_one_test_case_to_run
```
That is: each suite is a binary of its own!  This is a different
philosophy from many other test frameworks, where all suites and
sub-suites often are packed into the same binary.

## Test Dept. Suites are Holders for Standalone Cases ##
For an external test runner to be able to enumerate the
different test cases from a suite, the binary has to be able to state
which cases it contains.  This is done by specifying zero arguments to
the binary.  The default printout should be a list of cases:
```
> ./my_test_suite
test_foo
test_bar
test_fie
```
A final property of a test suite is that it has to return some
information to the runner regarding the actual test execution.  If the
suite returns zero, then everything went OK.  If it returns 1, then one
test failure occured.  If it returns 2, then two failures occured...
Since a runner normally will run only one case at a time from a
binary, the normal result is 1 or 0.

A potential runner execution could look like this:
```
> test_dept my_first_test_suite my_other_test_suite more_tests...
```
and the printout is test runner specific, even how it handles standard
output and standard error output.

## Potentially Dependent Test Cases are not Recommended but Supported ##
As a final twist, a suite binary is expected to accept more than one
test case at the same time, in any order.  For example:
```
> ./my_test_suite test_bar test_foo
```
which will run both the test\_bar and test\_foo cases and return the
accumulated number of failures as exit status.  This opens for a
possible (but not recommended) way of implementing test runners that
**could render dependent test cases**, but might be a good thing
once in a while if the runner would like to provoke
a [valgrind](http://en.wikipedia.org/wiki/Valgrind) run.

## A Test Dept. Conformant Suite ##
In conclusion.  A suite that conforms to the rules of the Test
Dept. framework shall:

  * return the names of all its test cases if zero arguments given
  * run all test cases whose names are supplied on the command line
  * return the cumulative failure count of all run cases as exit status
  * return -1 on strange arguments

# Test Dependencies #
Testing something, hereby called System Under Test (SUT), almost
always implies having dependencies to other parts of a system.  For
example, when testing a C-object-file, it almost always refers to
symbols from other object files.  Consider for example testing of
SUT.o which has dependencies to foo.o and bar.o:

![http://test-dept.googlecode.com/svn/trunk/doc/art/test_dependencies.png](http://test-dept.googlecode.com/svn/trunk/doc/art/test_dependencies.png)

A test program which tests the SUT is hardly interesting in
side-effects from bar.o or foo.o.  At least it is worth striving for
not to be dependent of them when constructing unit-tests.

What is often desirable is to short circuit different parts of the
dependency chain when testing parts of the SUT that accesses its
surroundings.  This is sometimes necessary.  For example, when testing
functionality in SUT that depends on foo, parts of the dependencies
can be directed back to the test program:

![http://test-dept.googlecode.com/svn/trunk/doc/art/stubbing.png](http://test-dept.googlecode.com/svn/trunk/doc/art/stubbing.png)

Doing this, a test case developer can simulate for example an
unsuccessful malloc or a broken file-open-function somewhere.
Sometimes this is called using a stub, a test-dummy, a mock-object or
something even more creative.  What it really is depends on the
scenario.  In this text it is henceforth called "stubbing".  Please
refer to later paragraphs in this file for a more comprehensive guide
on how this could be achieved for C-code.

# A C-implementation #
A C-implementation is provided in the framework.  And as far as that
C-implementation is concerned, a suite contains one or more cases and
zero or more of setup/teardown procedures.  The setup/teardown concept
is by no means a new invention.  It is used by many other types of
test frameworks.  Stacking many cases in the same suite makes good use
of a shared setup procedure, for example.

![http://test-dept.googlecode.com/svn/trunk/doc/art/suite.png](http://test-dept.googlecode.com/svn/trunk/doc/art/suite.png)

During a test run, independent cases are executed in rapid succession
together with setup code (if any) run in prior and teardown code (if
any) run after each case.  If instead we would have dependent cases,
a test run could look like this with all cases run from a single suite:

![http://test-dept.googlecode.com/svn/trunk/doc/art/running_suites.png](http://test-dept.googlecode.com/svn/trunk/doc/art/running_suites.png)

But, as mentioned earlier, this tends to make tests more fragile. It
is still recommended to run each case standalone and let the runner
group cases from the suites one by one after another. (Setup and
teardown code can still be shared, of course.)

With the C implementation a simple way to construct a test case is to
include test-dept.h and make test-functions:
```
/* foo_test.c */
#include <test-dept.h>
 
static int value;
 
void test_add_one() {
  int foo = value + 1;
  assert_equals(4, foo);
}

void test_init_value() {
  assert_equals(3, value);
}
 
void setup() {
  value = 3;
}
```
In order to run the tests, simply use something like this in your
makefile (after installing Test Dept. in your environment, of course):
```
TEST_SRCS=foo_test.c
 
include test-dept.mk
```
which will produce a binary called "foo\_test".  Then issue:
```
> make test_dept_run
```
which will run the default test runner that comes with Test Dept.  It
will call all test suite binaries.  In this case only "foo\_test".
Please note that the test suite binary will be run once per test case
in the suite.  Not once per suite.  There is a subtle difference being
that the former form of running tests forces them to be completely
independent of each other.

# Using Replacement Functions or Stubs #
Stubbing is often desirable when isolated tests on a SUT are required.
This is often the case when unit-testing.  The Test Dept. framework
offers a simple stubbing mechanism relying on symbol replacements in
object files.  A Behind-the-scenes description is presented on the
TestAutomation page.

Remembering the test dependencies discussion above; for example:
construct a test case for a SUT called sut, with stubs, like this:
```
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
  assert_string_equals("h", h);
  free(h);
}

void *always_failing_malloc() {
  return NULL;
}

void test_stringify_cannot_malloc_returns_sane_result() {
  replace_function(&malloc, &always_failing_malloc);
  char *h = stringify('h');
  assert_string_equals("cannot_stringify", h);
}

int negative_foo(int value) {
  return -99 * value;
}

void test_broken_foo_makes_fooify_return_subzero() {
  replace_function(&foo, &negative_foo);
  assert_equals(-1, fooify(3));
}

void teardown() {
  restore_function(&malloc);
  restore_function(&foo);
}
```
and the test-case should compile if sut\_test.c is added to the
makefile as described earlier in the simple example.

This is a complete makefile example which will work if you have
installed Test Dept. in your environment:
```
TEST_SRCS=sut_test.c

sut_DEPS: foo.o

include test-dept.mk
```
**Please note** that this simple way of expressing the makefiles expects a
file called sut.c to **exist**.  If not, the test will not compile.  If
you need to deviate from that simple rule you will have to specify
some dependencies by yourself.  Please refer to the included makefile
snippet for information on which dependencies are needed.

And that concludes a quick walkthrough of the Test Dept. framework.

# Directory Structure #
The software is structured like this when packaged as a source
tar-file:
```
 test-dept-<version>
  |
  +- COPYING          Licensing information for Test Dept.
  +- INSTALL          Installation information
  +- README           This file
  +- aclocal.m4       Autoconf file
  +- configure        Configuration script that creates a Makefile
  +- configure.ac     Autoconf input file
  +- examples         Example projects that use Test Dept.
  +- install-sh       Fallback installation program
  +- makefile.am      Automake input file
  +- makefile.in      Template Makefile
  +- missing          Stub for missing programs
  `- src              Scripts and makefile snippets that comprise the framework
```

# Credits #
All work by M Norrby with much help from Alexander Larsson and valuable input from
Mattias Rönnblom.

# Contact Information #
M Norrby norrby+test-dept@lysator.liu.se
# Automation #
In general, test automation is good. However, when test work is automated
it tends to cause a less flexible environment.  As a programmer you are
more tied to the framework used.  The reality looks somewhat like
the graph below:

![http://chart.apis.google.com/chart?chxt=x,y,x,y&chxl=0:|strict|full%20control|1:|manual|automatic|2:|Flexibility|3:|Automation&chxp=0,20,100|1,20,100|2,50|3,60&chxs=3,339933,14|2,3333dd,14&cht=lc&chs=400x225&chd=t:-1,100,50,30,27,25,23,22,21,20,20&nonsense=something_that_ends_with.png](http://chart.apis.google.com/chart?chxt=x,y,x,y&chxl=0:|strict|full%20control|1:|manual|automatic|2:|Flexibility|3:|Automation&chxp=0,20,100|1,20,100|2,50|3,60&chxs=3,339933,14|2,3333dd,14&cht=lc&chs=400x225&chd=t:-1,100,50,30,27,25,23,22,21,20,20&nonsense=something_that_ends_with.png)

The fact that automation causes a less flexible environment is not
necessarily a bad thing.  When programmers are forced in line simply
by not being able to make unnecessarily flexible solutions, projects
tend to focus.  At least that is the [Test Dept.](TestDept.md) philosophy.

## Different Ways of Automating Tests With Test Dept. ##
[Test Dept.](TestDept.md) is usable in a couple of ways:

  * Without fuzz; i e the usage described on the [frontpage](TestDept.md)
  * With some manual intervention, but still automated
  * Manual use of all, or some, of [Test Dept.](TestDept.md)'s convenience functionality

These different ways of usage are described below.

# How it Works #
When testing C code the systems under test are often object-files
or `o-files` for short. As described in the [introduction](TestDept.md)
systems under test are rarely standalone.  The `o-files` depend
on symbols from other `o-files`.  A unit test program can access
its compilation unit under test but it has no control over how
it really interacts with its dependencies:

![http://test-dept.googlecode.com/svn/trunk/doc/art/test_dependencies.png](http://test-dept.googlecode.com/svn/trunk/doc/art/test_dependencies.png)

The system under test might contain a reference to a foreign function
`foo()`:

![http://test-dept.googlecode.com/svn/trunk/doc/art/functions.png](http://test-dept.googlecode.com/svn/trunk/doc/art/functions.png)

If the symbol were to be replaced with something else in the sut,
the reality would look somewhat like the figure below instead:

![http://test-dept.googlecode.com/svn/trunk/doc/art/stub_functions.png](http://test-dept.googlecode.com/svn/trunk/doc/art/stub_functions.png)

The switching functionality illustrated above could be made controllable
from a unit test case.  That way it is possible to make runtime
switching, which allows for powerful unit testing.  If the function
symbol was forced to reference a switch function instead, the scenario
would look like this:

![http://test-dept.googlecode.com/svn/trunk/doc/art/stub_switch.png](http://test-dept.googlecode.com/svn/trunk/doc/art/stub_switch.png)

The [Test Dept.](TestDept.md) framework allows for such switching. It
automatically creates switches for all foreign symbols that are used
from the sut `o-file`. In practice this is accomplished by calling
`replace_function()` in the framework:
```
 void *my_own_malloc(size_t size) { /* ... */ }

 void test_something() {
   replace_function(&malloc, &my_own_malloc);
   call_something_that_uses_malloc();
   assert(some_condition);
   restore_function(&malloc);
 }
```
The key is the `replace_function()` function.

## Assembly language ##
Using solely C-code for creating a `replace_function(...)` function like
the one described above together with function switch proxies is impossible.
There is no way for a proxy to know which arguments to pass to a
wrapped function without having access to its prototype.

However, if we allow for an assembly language switching function, the proxy
function could just make a `jmp` to the chosen function, without disrupting
the stack or registers. Doing so surpasses the need for an explicit prototype
for the wrapped function.

This is how [Test Dept.](TestDept.md) works. It replaces the foreign symbols
in the `sut.o` creating a `sut_using_proxies.o` file. The latter object
file contains references to switching functions that are implemented in
assembly language. Each switching function has access to a function pointer
pointing either to the original function or a stub function.

Those pointers are accessible from the test-program. And the
`replace_function()` mentioned earlier just manipulates them to
redirect calls.

### Code Generation ###
Everything needed for stubbing functions is generated automatically
when a test-case is added to the `TEST_SRCS` makefile variable.
[Test Dept.](TestDept.md) will generate all proxy functions needed.

Grey boxes in the image below depict generated files:

![http://test-dept.googlecode.com/svn/trunk/doc/art/generating_code.png](http://test-dept.googlecode.com/svn/trunk/doc/art/generating_code.png)

### Simple and Strict ###
The example above based on automatically generated assembly code
is a fairly easy way of managing and creating unit test cases. But,
as mentioned earlier, it does not leave much room for changes. It
is simple, but the programmer will have to stick to these rules:

  * Use only on supported platforms (not as portable as other solutions)
  * Name test cases like the SUT but with a `_test` suffix

The assembly approach can be accomodated by including the `test-dept.mk`
Makefile snippet.

## C-version of Stubs ##
Instead of using the simple assembly language generating approach
[Test Dept.](TestDept.md) can generate prototypes for function replacement
named `test_dept_<stubbed_function>_set(...)`. For example, for malloc:
```
test_dept_malloc_set(...);
```
Such prototypes are generated from a file that specifies which functions
a user might want to stub. From that file a header file is generated and
can be included by test cases.

![http://test-dept.googlecode.com/svn/trunk/doc/art/generating_c_code.png](http://test-dept.googlecode.com/svn/trunk/doc/art/generating_c_code.png)
Using this prototype generation is more portable. Include `test-dept-cstubs.mk`.

## Full Flexibility ##
The do-it-yourself version can be achieved by including `test-dept-rudimentary.mk`.
# Introduction #

Debugger overuse is not a good thing. It is however inevitable that debuggers are quite useful for pinpointing unexpected and hard to find errors, especially binaries that suddenly freeze or loop forever. Using a debugger together with Test Dept. is straightforward.

# When to Debug #

Be aware of when to bring forth a debugger. There is almost always other ways of narrowing down the area of interest to find where the problem lies. On every occasion when an assertion fails there should be no need for a debugger. Try to triangulate the error by writing yet another test-case instead.

When a test program suddenly hangs due to eternal loops or misdirected system calls there is often need of debugging, though.

# How to Debug #

Test Dept. test suite binaries print a newline separated list of test case names
when launched without command line arguments, like so:
```
> ./my_test
test_foo
test_bar
test_fie
test_gazonk
```
The binary runs a named test case when the corresponding test case name is supplied
as command line argument. Launching like this runs `test_fie` for example:
```
> ./my_test test_fie
```
All debuggers supply a means for starting a binary with arguments. Use
your desired test case name as a single command line argument and debugging should
commence normally. In `gdb(1)` for example, you may run your binary like this:
```
> gdb my_test
...
...
(gdb) run test_fie
```

Also **don't forget to compile with `-g`**.
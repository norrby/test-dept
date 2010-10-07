dnl Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)

AC_INIT([Test Dept], [0.14a], [norrby+test-dept@lysator.liu.se])

AM_INIT_AUTOMAKE([1.9 foreign])
AC_LANG(C)
AC_PROG_CC
AC_CONFIG_FILES([makefile src/makefile examples/makefile])
AS_IF([test "x$lt_cv_prog_gnu_ld" = xyes],	
	    [AC_SUBST([LDFLAGS_UNRESOLVED],
	    [-Wl,--unresolved-symbols=ignore-in-object-files])])
AS_IF([$CC -Wl,-znodefs 2>/dev/null],[AC_SUBST([LDFLAGS_UNRESOLVED],[-Wl,-znodefs])]])
AC_OUTPUT

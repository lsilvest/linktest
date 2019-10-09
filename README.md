## linktest

Linking against another R package's C/C++ code.

### Motivation

Some packages give R access to an underlying C/C++ library
(e.g. [RcppCCTZ]()). Under certain conditions, it is possible to
access this C/C++ library from another package. This is alluded to in
this [Stackoverflow answer](https://stackoverflow.com/a/42287094) by
@nathan-russel. There is however a little bit more work to do to make
this portable. In particular Windows and MacOS need a bit more
help. In the Windows case, the library location needs to also indicate
the archicture. In the MacOS case, we need to tweak the produced
dynamic library to ensure it has the correct path to the library it
references.

### Solution

For resolving the Windows case we simply add the architecture in `Makevars.win`.

In the case of MacOS we have to generate the following command:

~~~
install_name_tool -change RcppCCTZ.so /usr/local/lib/R/3.6/site-library/RcppCCTZ/libs/RcppCCTZ.so linktest.so
~~~

Which changes where `RcppCCTZ.so` will be fetched from:

~~~
lsilvest:~/repos$ otool -L /usr/local/lib/R/3.5/site-library/linktest/libs/linktest.so
/usr/local/lib/R/3.5/site-library/linktest/libs/linktest.so:
	linktest.so (compatibility version 0.0.0, current version 0.0.0)
	/usr/local/opt/gcc/lib/gcc/8/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.25.0)
	RcppCCTZ.so (compatibility version 0.0.0, current version 0.0.0)
	/usr/local/opt/r/lib/R/lib/libR.dylib (compatibility version 3.5.0, current version 3.5.1)
	/usr/local/opt/gettext/lib/libintl.8.dylib (compatibility version 10.0.0, current version 10.5.0)
	/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 1349.93.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.60.2)
	/usr/local/lib/gcc/8/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
~~~

to:

~~~
lsilvest:~/repos$ otool -L /usr/local/lib/R/3.5/site-library/linktest/libs/linktest.so
/usr/local/lib/R/3.5/site-library/linktest/libs/linktest.so:
	linktest.so (compatibility version 0.0.0, current version 0.0.0)
	/usr/local/opt/gcc/lib/gcc/8/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.25.0)
	/usr/local/lib/R/3.5/site-library/RcppCCTZ/libs/RcppCCTZ.so (compatibility version 0.0.0, current version 0.0.0)
	/usr/local/opt/r/lib/R/lib/libR.dylib (compatibility version 3.5.0, current version 3.5.1)
	/usr/local/opt/gettext/lib/libintl.8.dylib (compatibility version 10.0.0, current version 10.5.0)
	/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 1349.93.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.60.2)
	/usr/local/lib/gcc/8/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
~~~

In order to generate this we add an additional target to `Makevars` as described in [Writing R Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Using-Makevars):

~~~ Makefile
.PHONY: all change_install_name
change_install_name: linktest.so
	install_name_tool -change RcppCCTZ.so /usr/local/lib/R/3.6/site-library/RcppCCTZ/libs/RcppCCTZ.so linktest.so
~~~

This additional target is added via a `configure` script also
described in [Writing R
Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Configure-example).

See branch `install_libs` for an alternative method.

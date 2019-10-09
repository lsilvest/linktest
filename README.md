## linktest

Linking against another R package's C/C++ code.

### Motivation

The master branch presents the motivation and a solution for MacOS
that works by adding a new target to `Makevars` using a `configure`
script. Here we present a solution based on the `install.libs.R` file.

### Solution

To generate the needed `install_name_tool` command:

~~~
install_name_tool -change RcppCCTZ.so /usr/local/lib/R/3.6/site-library/RcppCCTZ/libs/RcppCCTZ.so linktest.so
~~~

we use the following script in the `install.libs.R` file:

~~~ R
uname <- system("uname", TRUE)

if (uname == "Darwin") {
  RCPPCCTZ <- paste0('RcppCCTZ', SHLIB_EXT)
  FULL_PATH_RCPPCCTZ <- file.path(installed.packages()['RcppCCTZ','LibPath'][1], "RcppCCTZ", "libs", paste0("RcppCCTZ", SHLIB_EXT))

  INSTALL_NAME_TOOL_COMMAND <- paste("install_name_tool -change", RCPPCCTZ, FULL_PATH_RCPPCCTZ, paste0("linktest", SHLIB_EXT))
  print(INSTALL_NAME_TOOL_COMMAND)
  system(INSTALL_NAME_TOOL_COMMAND)
}

## below we also copy ".rds", otherwise we get a `NOTE` during `R CMD check`:
files <- Sys.glob(paste0("*[", SHLIB_EXT, " | .rds]"))
dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive = TRUE, showWarnings = FALSE)
file.copy(files, dest, overwrite = TRUE)
~~~

The `install.libs.R` file is run as part of package installation and
is documented in [Writing R
Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Package-subdirectories).

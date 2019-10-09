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


AC_INIT([linktest], 0.0.0.9000) dnl package name, version

RCPPCCTZ=`"${R_HOME}/bin/Rscript" -e "cat(sprintf('RcppCCTZ%s', .Platform[[['dynlib.ext']]]))" 2> /dev/null`
FULL_PATH_RCPPCCTZ=`${R_HOME}/bin/Rscript -e "cat(sprintf('%s/RcppCCTZ/libs/RcppCCTZ%s', installed.packages()[['RcppCCTZ','LibPath']][[1]], .Platform[[['dynlib.ext']]]))" 2> /dev/null`

dnl A user-specifiable option
UNAME=`uname`
if [[ "$UNAME" = "Linux" ]] ; then
   CHANGE_INSTALL_NAME=".PHONY: all change_install_name
change_install_name: $(SHLIB)
	install_name_tool -change ${RCPPCCTZ} ${FULL_PATH_RCPPCCTZ} \${SHLIB}"
else
   CHANGE_INSTALL_NAME=""
fi

dnl substitute RODBC_CPPFLAGS and LIBS
AC_SUBST(RCPPCCTZ)
AC_SUBST(FULL_PATH_RCPPCCTZ)
AC_SUBST(CHANGE_INSTALL_NAME)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

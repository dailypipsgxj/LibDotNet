AC_INIT([libdotnet],
        [0.1],
        [https://github.com/chebizarro/LibDotNet/issues],
        [dia3],
        [https://github.com/chebizarro/LibDotNet])

AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])
AM_MAINTAINER_MODE([enable])

dnl AM_SILENT_RULES([yes])

AC_PROG_CC
AM_PROG_AR
AM_PROG_VALAC

dnl ***************************************************************************
dnl Check for Windows
dnl ***************************************************************************
AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    ;;
  *)
    platform_win32=no
    native_win32=no
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")

LT_INIT([win32-dll])


dnl ***************************************************************************
dnl Internationalization
dnl ***************************************************************************
IT_PROG_INTLTOOL(0.40)
AM_GNU_GETTEXT_VERSION([0.17])
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[The name of the gettext domain])

pkg_modules="gobject-2.0 gee-0.8"

AC_SUBST(pkg_modules)

PKG_CHECK_MODULES([LIBDOTNET], [gobject-2.0, gee-0.8])

AC_CONFIG_FILES([
	Makefile
	src/libdotnet-0.1.pc
	src/Makefile
	po/Makefile.in
	tests/Makefile
	vapi/Makefile
])

AC_OUTPUT

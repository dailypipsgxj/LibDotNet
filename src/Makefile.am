include $(top_srcdir)/src/sourcefiles.am

AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(LIBDOTNET_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

lib_LTLIBRARIES = libdotnet.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = libdotnet-0.1.vapi libdotnet-0.1.deps

libdotnet_la_SOURCES = $(LIBDOTNET_SOURCES)

libdotnet_la_LDFLAGS = 
	
libdotnet_la_VALAFLAGS =  \
	--library libdotnet-0.1 --vapi libdotnet-0.1.vapi -H libdotnet.h

libdotnet_la_LIBADD = $(LIBDOTNET_LIBS)


if PLATFORM_WIN32
libdotnet_la_LDFLAGS += -no-undefined
endif

if NATIVE_WIN32
libdotnet_la_LDFLAGS += -export-dynamic
endif

libdotnetincludedir = $(includedir)/libdotnet-0.1
libdotnetinclude_HEADERS = \
	libdotnet.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libdotnet-0.1.pc

EXTRA_DIST = \
	libdotnet-0.1.pc.in

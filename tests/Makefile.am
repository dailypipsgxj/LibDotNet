include $(top_srcdir)/base.am
include $(top_srcdir)/tests/testsources.am

junk_files =

AM_VALAFLAGS = $(LIBDOTNET_VALAFLAGS) \
	--pkg config \
	--pkg libdotnet-0.1 \
	-g --save-temps


AM_CPPFLAGS = $(LIBDOTNET_CFLAGS) \
	-w
	
AM_LDFLAGS = $(LIBDOTNET_LDFLAGS)

TEST_LIBS = $(LIBDOTNET_LIBS) \
	$(top_builddir)/src/libdotnet.la

# Unit tests for LibDitNet applications

TEST_PROGS += test_libdotnet

check_PROGRAMS = test_libdotnet

test_libdotnet_SOURCES =  \
	testcase.vala \
	testmain.vala \
	$(TEST_COLLECTIONS_GENERIC)
	
test_libdotnet_DEPENDENCIES = \
	$(top_builddir)/src/libdotnet-0.1.vapi	
	
test_libdotnet_LDADD = $(TEST_LIBS)

junk_files += \
	$(test_libdotnet_SOURCES:.vala=.c) \
	test_libdotnet_vala.stamp

noinst_PROGRAMS = $(TEST_PROGS)

dist-hook:
	cd $(distdir) && rm -f $(junk_files)

CLEANFILES = \
	$(junk_files)

-include $(top_srcdir)/git.mk

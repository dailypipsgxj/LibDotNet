junk_files =

AM_VALAFLAGS = $(DIA3_CORE_VALAFLAGS) \
	$(DIA_VALAFLAGS) 
	
AM_CPPFLAGS = $(DIA3_CORE_CFLAGS) \
	$(DIA_CFLAGS)
	
AM_LDFLAGS = $(DIA3_CORE_LDFLAGS)

TEST_LIBS = $(DIA3_CORE_LIBS) \
	$(DIA3_APP_LIBS) \
	$(top_builddir)/libdia3/libdia3.la

# Unit tests for Dia3 applications

TEST_PROGS += test_dia3

check_PROGRAMS = test_dia3

test_dia3_SOURCES =  \
	testcase.vala \
	testmain.vala \
	../src/dia3.vala \
	../src/default-shell.vala \
	mocks/mock-shell.vala \
	mocks/mock-application.vala \
	libdia3/testpluginmanager.vala
	
test_dia3_LDADD = $(TEST_LIBS)

junk_files += \
	$(test_dia3_SOURCES:.vala=.c) \
	test_dia3_vala.stamp

noinst_PROGRAMS = $(TEST_PROGS)

dist-hook:
	cd $(distdir) && rm -f $(junk_files)

CLEANFILES = \
	$(junk_files)

-include $(top_srcdir)/git.mk

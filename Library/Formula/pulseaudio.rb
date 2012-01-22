require 'formula'

class Pulseaudio < Formula
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-1.1.tar.xz'
  head 'git://anongit.freedesktop.org/pulseaudio/pulseaudio'
  homepage 'http://www.pulseaudio.org/'
  md5 '17d21df798cee407b769c6355fae397a'

  depends_on "intltool"
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on "speex"
  depends_on "json-c"
  depends_on "libsamplerate"

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-mac-sysroot=/Developer/SDKs/MacOSX10.7.sdk"
    system "make install"
  end
end

__END__



# Despite proper if-statements in Makefile.in, automake was still adding
# rules to install/uninstall for udev configuration. This strips these rules.

diff -ur pulseaudio-1.1/src/Makefile.in pulseaudio-1.1-patched/src/Makefile.in
--- pulseaudio-1.1/src/Makefile.in	2011-10-20 15:12:24.000000000 +0200
+++ pulseaudio-1.1-patched/src/Makefile.in	2012-01-18 15:58:42.000000000 +0100
@@ -88,7 +88,6 @@
 @OS_IS_DARWIN_TRUE@am__append_2 = -Wl,-headerpad_max_install_names -headerpad_max_install_names
 DIST_COMMON = $(am__dist_alsapaths_DATA_DIST) \
 	$(am__dist_alsaprofilesets_DATA_DIST) \
-	$(am__dist_udevrules_DATA_DIST) \
 	$(am__pulseinclude_HEADERS_DIST) $(srcdir)/Makefile.am \
 	$(srcdir)/Makefile.in $(top_srcdir)/orc.mak \
 	$(top_srcdir)/src/daemon/daemon.conf.in \
@@ -404,7 +403,7 @@
 	"$(DESTDIR)$(bindir)" "$(DESTDIR)$(pulselibexecdir)" \
 	"$(DESTDIR)$(bindir)" "$(DESTDIR)$(dbuspolicydir)" \
 	"$(DESTDIR)$(alsapathsdir)" "$(DESTDIR)$(alsaprofilesetsdir)" \
-	"$(DESTDIR)$(udevrulesdir)" "$(DESTDIR)$(pulseconfdir)" \
+	"$(DESTDIR)$(pulseconfdir)" \
 	"$(DESTDIR)$(xdgautostartdir)" "$(DESTDIR)$(pulseincludedir)"
 LTLIBRARIES = $(lib_LTLIBRARIES) $(modlibexec_LTLIBRARIES) \
 	$(noinst_LTLIBRARIES)
@@ -2478,10 +2477,8 @@
 	modules/alsa/mixer/profile-sets/native-instruments-traktorkontrol-s4.conf \
 	modules/alsa/mixer/profile-sets/native-instruments-korecontroller.conf \
 	modules/alsa/mixer/profile-sets/kinect-audio.conf
-am__dist_udevrules_DATA_DIST =  \
-	modules/alsa/mixer/profile-sets/90-pulseaudio.rules
 DATA = $(dbuspolicy_DATA) $(dist_alsapaths_DATA) \
-	$(dist_alsaprofilesets_DATA) $(dist_udevrules_DATA) \
+	$(dist_alsaprofilesets_DATA) \
 	$(pulseconf_DATA) $(xdgautostart_DATA)
 am__pulseinclude_HEADERS_DIST = pulse/cdecl.h pulse/channelmap.h \
 	pulse/context.h pulse/def.h pulse/error.h \
@@ -2743,7 +2740,6 @@
 top_build_prefix = @top_build_prefix@
 top_builddir = @top_builddir@
 top_srcdir = @top_srcdir@
-udevrulesdir = @udevrulesdir@
 pulseincludedir = $(includedir)/pulse
 pulsecoreincludedir = $(includedir)/pulsecore
 pulselibexecdir = $(libexecdir)/pulse
@@ -3343,9 +3339,6 @@
 @HAVE_ALSA_TRUE@		modules/alsa/mixer/profile-sets/native-instruments-korecontroller.conf \
 @HAVE_ALSA_TRUE@		modules/alsa/mixer/profile-sets/kinect-audio.conf
 
-@HAVE_ALSA_TRUE@@HAVE_UDEV_TRUE@dist_udevrules_DATA = \
-@HAVE_ALSA_TRUE@@HAVE_UDEV_TRUE@		modules/alsa/mixer/profile-sets/90-pulseaudio.rules
-
 @HAVE_ALSA_TRUE@dist_alsapaths_DATA = \
 @HAVE_ALSA_TRUE@		modules/alsa/mixer/paths/analog-input-aux.conf \
 @HAVE_ALSA_TRUE@		modules/alsa/mixer/paths/analog-input.conf \
@@ -8306,26 +8299,7 @@
 	test -n "$$files" || exit 0; \
 	echo " ( cd '$(DESTDIR)$(alsaprofilesetsdir)' && rm -f" $$files ")"; \
 	cd "$(DESTDIR)$(alsaprofilesetsdir)" && rm -f $$files
-install-dist_udevrulesDATA: $(dist_udevrules_DATA)
-	@$(NORMAL_INSTALL)
-	test -z "$(udevrulesdir)" || $(MKDIR_P) "$(DESTDIR)$(udevrulesdir)"
-	@list='$(dist_udevrules_DATA)'; test -n "$(udevrulesdir)" || list=; \
-	for p in $$list; do \
-	  if test -f "$$p"; then d=; else d="$(srcdir)/"; fi; \
-	  echo "$$d$$p"; \
-	done | $(am__base_list) | \
-	while read files; do \
-	  echo " $(INSTALL_DATA) $$files '$(DESTDIR)$(udevrulesdir)'"; \
-	  $(INSTALL_DATA) $$files "$(DESTDIR)$(udevrulesdir)" || exit $$?; \
-	done
 
-uninstall-dist_udevrulesDATA:
-	@$(NORMAL_UNINSTALL)
-	@list='$(dist_udevrules_DATA)'; test -n "$(udevrulesdir)" || list=; \
-	files=`for p in $$list; do echo $$p; done | sed -e 's|^.*/||'`; \
-	test -n "$$files" || exit 0; \
-	echo " ( cd '$(DESTDIR)$(udevrulesdir)' && rm -f" $$files ")"; \
-	cd "$(DESTDIR)$(udevrulesdir)" && rm -f $$files
 install-pulseconfDATA: $(pulseconf_DATA)
 	@$(NORMAL_INSTALL)
 	test -z "$(pulseconfdir)" || $(MKDIR_P) "$(DESTDIR)$(pulseconfdir)"
@@ -8571,7 +8545,7 @@
 install-binPROGRAMS: install-libLTLIBRARIES
 
 installdirs:
-	for dir in "$(DESTDIR)$(libdir)" "$(DESTDIR)$(modlibexecdir)" "$(DESTDIR)$(bindir)" "$(DESTDIR)$(pulselibexecdir)" "$(DESTDIR)$(bindir)" "$(DESTDIR)$(dbuspolicydir)" "$(DESTDIR)$(alsapathsdir)" "$(DESTDIR)$(alsaprofilesetsdir)" "$(DESTDIR)$(udevrulesdir)" "$(DESTDIR)$(pulseconfdir)" "$(DESTDIR)$(xdgautostartdir)" "$(DESTDIR)$(pulseincludedir)"; do \
+	for dir in "$(DESTDIR)$(libdir)" "$(DESTDIR)$(modlibexecdir)" "$(DESTDIR)$(bindir)" "$(DESTDIR)$(pulselibexecdir)" "$(DESTDIR)$(bindir)" "$(DESTDIR)$(dbuspolicydir)" "$(DESTDIR)$(alsapathsdir)" "$(DESTDIR)$(alsaprofilesetsdir)" "$(DESTDIR)$(pulseconfdir)" "$(DESTDIR)$(xdgautostartdir)" "$(DESTDIR)$(pulseincludedir)"; do \
 	  test -z "$$dir" || $(MKDIR_P) "$$dir"; \
 	done
 install: $(BUILT_SOURCES)
@@ -8629,7 +8603,7 @@
 info-am:
 
 install-data-am: install-dbuspolicyDATA install-dist_alsapathsDATA \
-	install-dist_alsaprofilesetsDATA install-dist_udevrulesDATA \
+	install-dist_alsaprofilesetsDATA \
 	install-pulseconfDATA install-pulseincludeHEADERS \
 	install-xdgautostartDATA
 
@@ -8683,7 +8657,7 @@
 uninstall-am: uninstall-binPROGRAMS uninstall-binSCRIPTS \
 	uninstall-dbuspolicyDATA uninstall-dist_alsapathsDATA \
 	uninstall-dist_alsaprofilesetsDATA \
-	uninstall-dist_udevrulesDATA uninstall-libLTLIBRARIES \
+	uninstall-libLTLIBRARIES \
 	uninstall-modlibexecLTLIBRARIES uninstall-pulseconfDATA \
 	uninstall-pulseincludeHEADERS uninstall-pulselibexecPROGRAMS \
 	uninstall-xdgautostartDATA
@@ -8702,7 +8676,7 @@
 	install-binPROGRAMS install-binSCRIPTS install-data \
 	install-data-am install-dbuspolicyDATA \
 	install-dist_alsapathsDATA install-dist_alsaprofilesetsDATA \
-	install-dist_udevrulesDATA install-dvi install-dvi-am \
+	install-dvi install-dvi-am \
 	install-exec install-exec-am install-exec-hook install-html \
 	install-html-am install-info install-info-am \
 	install-libLTLIBRARIES install-man \
@@ -8717,7 +8691,7 @@
 	uninstall-binSCRIPTS uninstall-dbuspolicyDATA \
 	uninstall-dist_alsapathsDATA \
 	uninstall-dist_alsaprofilesetsDATA \
-	uninstall-dist_udevrulesDATA uninstall-hook \
+	uninstall-hook \
 	uninstall-libLTLIBRARIES uninstall-modlibexecLTLIBRARIES \
 	uninstall-pulseconfDATA uninstall-pulseincludeHEADERS \
 	uninstall-pulselibexecPROGRAMS uninstall-xdgautostartDATA



# The default configuration has no support for detecting CoreAudio.
# This is a simple patch adding that.

diff -ur pulseaudio-1.1/src/daemon/default.pa.in pulseaudio-1.1-patched/src/daemon/default.pa.in
--- pulseaudio-1.1/src/daemon/default.pa.in	2011-10-20 15:12:05.000000000 +0200
+++ pulseaudio-1.1-patched/src/daemon/default.pa.in	2012-01-18 16:33:17.000000000 +0100
@@ -72,6 +72,10 @@
 .ifexists module-hal-detect@PA_SOEXT@
 load-module module-hal-detect
 .else
+], @HAVE_COREAUDIO@, 1, [dnl
+.ifexists module-coreaudio-detect@PA_SOEXT@
+load-module module-coreaudio-detect
+.else
 ], [dnl
 .ifexists module-detect@PA_SOEXT@
 ])dnl
diff -ur pulseaudio-1.1/src/daemon/system.pa.in pulseaudio-1.1-patched/src/daemon/system.pa.in
--- pulseaudio-1.1/src/daemon/system.pa.in	2011-10-20 14:54:16.000000000 +0200
+++ pulseaudio-1.1-patched/src/daemon/system.pa.in	2012-01-18 16:33:41.000000000 +0100
@@ -29,6 +29,10 @@
 .ifexists module-hal-detect@PA_SOEXT@
 load-module module-hal-detect
 .else
+], @HAVE_COREAUDIO@, 1, [dnl
+.ifexists module-coreaudio-detect@PA_SOEXT@
+load-module module-coreaudio-detect
+.else
 ], [dnl
 .ifexists module-detect@PA_SOEXT@
 ])dnl
diff -ur pulseaudio-1.1/src/daemon/configure.ac pulseaudio-1.1-patched/src/daemon/configure.ac
--- pulseaudio-1.1/configure.ac	2011-10-20 15:12:05.000000000 +0200
+++ pulseaudio-1.1-patched/configure.ac	2012-01-18 17:12:52.000000000 +0100
@@ -713,6 +713,8 @@
 
 AM_CONDITIONAL([HAVE_COREAUDIO], [test "x$HAVE_COREAUDIO" = "x1" && test "x$enable_coreaudio_output" != "xno"])
 
+AC_SUBST(HAVE_COREAUDIO)
+
 #### ALSA support (optional) ####
 
 AC_ARG_ENABLE([alsa],
diff -ur pulseaudio-1.1/src/daemon/configure pulseaudio-1.1-patched/src/daemon/configure
--- pulseaudio-1.1/configure	2011-10-20 15:12:21.000000000 +0200
+++ pulseaudio-1.1-patched/configure	2012-01-18 17:17:17.000000000 +0100
@@ -727,6 +727,7 @@
 ASOUNDLIB_CFLAGS
 HAVE_COREAUDIO_FALSE
 HAVE_COREAUDIO_TRUE
+HAVE_COREAUDIO
 HAVE_OSS_WRAPPER_FALSE
 HAVE_OSS_WRAPPER_TRUE
 HAVE_OSS_OUTPUT_FALSE
@@ -19951,6 +19952,12 @@
   HAVE_COREAUDIO_FALSE=
 fi
 
+if test "x$HAVE_COREAUDIO" = "x1"; then :
+
+$as_echo "#define HAVE_COREAUDIO 1" >>confdefs.h
+
+fi
+
 
 #### ALSA support (optional) ####
 

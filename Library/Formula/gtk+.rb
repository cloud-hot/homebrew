require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.10.tar.xz'
  sha256 'ea56e31bb9d6e19ed2e8911f4c7ac493cb804431caa21cdcadae625d375a0e89'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def patches
    # Patches a build failure, see: http://trac.macports.org/ticket/30281
    { :p0 => DATA }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gdktarget=quartz",
                          "--disable-glibtest",
                          "--disable-introspection",
                          "--disable-visibility"
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end

__END__
--- tests/Makefile.in.orig 2011-07-21 12:34:27.000000000 -0400
+++ tests/Makefile.in  2011-07-21 12:34:27.000000000 -0400
@@ -89,7 +89,6 @@
 @HAVE_CXX_TRUE@am_autotestkeywords_OBJECTS =  \
 @HAVE_CXX_TRUE@ autotestkeywords-autotestkeywords.$(OBJEXT)
 autotestkeywords_OBJECTS = $(am_autotestkeywords_OBJECTS)
-autotestkeywords_LDADD = $(LDADD)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
 am__v_lt_0 = --silent
@@ -685,6 +684,7 @@
 testtooltips_DEPENDENCIES = $(TEST_DEPS)
 testvolumebutton_DEPENDENCIES = $(TEST_DEPS)
 testwindows_DEPENDENCIES = $(TEST_DEPS)
+autotestkeywords_LDADD = $(LDADDS)
 flicker_LDADD = $(LDADDS)
 simple_LDADD = $(LDADDS)
 print_editor_LDADD = $(LDADDS)

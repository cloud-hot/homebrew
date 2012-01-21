require 'formula'

class Gimp < Formula
  url 'ftp://ftp.gimp.org/pub/gimp/v2.7/gimp-2.7.4.tar.bz2'
  homepage 'http://www.gimp.org/'
  md5 'bda95a29c3483b8ff458b06b1543f867'

  depends_on 'atk'
  depends_on 'gtk+'
  depends_on 'babl'
  depends_on 'gegl'
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gdk-pixbuf'
  depends_on 'pkg-config' => :build
  depends_on 'hicolor-icon-theme' => :optional

  def install
    ENV.append 'LDFLAGS', '-framework Carbon'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-python"
    system "make install"

    gtk_update_icon_cache_path = "#{HOMEBREW_PREFIX}/bin/gtk-update-icon-cache"
    system "test -x #{gtk_update_icon_cache_path} && #{gtk_update_icon_cache_path} -f -t #{HOMEBREW_PREFIX}/share/icons/hicolor || ! test -x #{gtk_update_icon_cache_path}"
  end
end

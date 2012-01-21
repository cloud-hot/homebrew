require 'formula'

class Automake < Formula
  url 'http://ftpmirror.gnu.org/automake/automake-1.11.2.tar.bz2'
  homepage 'http://www.gnu.org/software/automake'
  md5 '18194e804d415767bae8f703c963d456'

  depends_on 'autoconf'

  keg_only <<-EOS.undent
    OSX ships an older automake. In order to prevent conflicts with the
    system automake, this formula is keg-only.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    # Include the Homebrew aclocal path in the search path.
    (share + "aclocal/dirlist").write "/usr/local/share/aclocal"
  end
end

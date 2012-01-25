require 'formula'

class M4 < Formula
  url 'http://ftpmirror.gnu.org/m4/m4-1.4.16.tar.xz'
  homepage 'http://www.gnu.org/software/m4'
  md5 '7548ec061a1ba993790159764f522d0e'

  keg_only <<-EOS.undent
    OSX ships an older m4. In order to prevent conflicts with the
    system m4, this formula is keg-only.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

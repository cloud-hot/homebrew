require 'formula'

class Znc < Formula
  url 'http://znc.in/releases/archive/znc-0.202.tar.gz'
  md5 '3c6ff4620e139e3d9745cd53111bab20'
  homepage 'http://en.znc.in/wiki/ZNC'
  head 'https://github.com/znc/znc.git'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional
  if ARGV.build_head?
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  def options
    [['--enable-debug', "Compile ZNC with --enable-debug"]]
  end

  def install
    system "./autogen.sh" if ARGV.build_head?

    args = ["--prefix=#{prefix}", "--enable-extra"]
    args << "--enable-debug" if ARGV.include? '--enable-debug'
    system "./configure", *args

    system "make install"
  end
end

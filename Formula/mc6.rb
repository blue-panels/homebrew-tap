class Mc6 < Formula
  desc "Terminal file manager, a Midnight Commander fork with panel plugins"
  homepage "https://github.com/ilia-maslakov/mcdev"
  url "https://github.com/ilia-maslakov/mcdev/releases/download/v6.0.4/mc6-6.0.4.tar.gz"
  sha256 "b4726802405b7adb1c36330a36dc13043bf3b625fe6920b0cafb7d658bdcabd2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/blue-panels/tap"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libssh2"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "midnight-commander", "minio-mc", because: "both install an `mc` binary"

  def install
    # Both switches are explicit: auto would follow whatever happens to be on
    # the runner. Samba is off, libsmbclient is a large tree for a rare plugin.
    args = %w[
      --with-screen=slang
      --enable-vfs-sftp
      --enable-mcterm=yes
      --enable-panel-plugin-samba=no
      --enable-panel-plugin-mongo=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # configure writes the tools it found into the syntax file, and under
    # Homebrew those are the shims rather than the real binaries.
    inreplace share/"mc/syntax/Syntax" do |s|
      s.gsub! Superenv.shims_path.to_s, "/usr/bin"
    end
  end

  test do
    # mc sets its terminal up before it gets to printing a version, and the
    # test environment has no TERM.
    assert_match version.to_s, with_env(TERM: "xterm") { shell_output("#{bin}/mc --version") }
  end
end

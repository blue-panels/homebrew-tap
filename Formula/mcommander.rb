class Mcommander < Formula
  desc "Twin-panel terminal file manager with panel plugins"
  homepage "https://blue-panels.github.io/mcommander/"
  url "https://github.com/blue-panels/mcommander/releases/download/v6.1.0/mcommander-6.1.0.tar.gz"
  sha256 "32fa33be816f9bb40705068ae7b468c2ad640dead8da378a878656562d59fd88"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
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

  def install
    # Both switches are explicit: auto would follow whatever happens to be on
    # the runner. Samba is off, libsmbclient is a large tree for a rare plugin.
    args = %w[
      --with-screen=slang
      --enable-panel-plugin-sftp=yes
      --enable-panel-plugin-samba=no
      --enable-panel-plugin-mongo=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # configure writes the tools it found into the syntax file, and under
    # Homebrew those are the shims rather than the real binaries.
    inreplace share/"mcommander/syntax/Syntax" do |s|
      s.gsub! Superenv.shims_path.to_s, "/usr/bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcommander --version")
  end
end

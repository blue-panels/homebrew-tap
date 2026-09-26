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

  bottle do
    root_url "https://ghcr.io/v2/blue-panels/tap"
    rebuild 1
    sha256 arm64_tahoe:  "f6e15588c283d373d5ffa1cb43b9e4e6ce537f2f41c471544549b03c678a89e6"
    sha256 x86_64_linux: "70e5f0e91418fd07f497591b2892d81e5b2ceffeefe48ad0fac3d14468987a54"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libssh2"
  depends_on "lua"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "s-lang"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext"
  end

  # The release archive carries the po files, not the catalogs built from them,
  # so msgfmt is needed at build time; glibc provides libintl itself.
  on_linux do
    depends_on "gettext" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    # Both switches are explicit: auto would follow whatever happens to be on
    # the runner. Samba is off, libsmbclient is a large tree for a rare plugin.
    args = %w[
      --with-screen=slang
      --enable-lua-plugin=yes
      --enable-panel-plugin-sftp=yes
      --enable-panel-plugin-samba=no
      --enable-panel-plugin-mongo=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # configure writes the tools it found into the syntax file, and under
    # Homebrew on macOS those are the shims rather than the real binaries.
    # On Linux it finds no shims there, so nothing to replace is no error.
    inreplace pkgshare/"syntax/Syntax", Superenv.shims_path.to_s, "/usr/bin",
              audit_result: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcommander --version")
  end
end

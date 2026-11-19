class Bluerig < Formula
  desc "Terminal IDE, a continuation of cooledit"
  homepage "https://github.com/blue-panels/bluerig"
  url "https://github.com/blue-panels/bluerig/releases/download/bluerig-1.0.2/bluerig-1.0.2.tar.gz"
  sha256 "ce506d80b8a68fc41e8de228793dee61a521a0160b7546f2b1d7833281ed31ea"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^bluerig[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/blue-panels/tap"
    sha256 arm64_tahoe:  "7ac9f98a18a56e85945c376ee2636b164176b03764f5470ad7699b43cd969302"
    sha256 x86_64_linux: "30ddcb859bd942a9686d851b50955ca79133fb16a2c0ccec2d1c3eec0eaeb048"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "json-glib"
  depends_on "lua"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  # The release archive carries the po files, not the catalogs built from them,
  # so msgfmt is needed at build time; glibc provides libintl itself.
  on_linux do
    depends_on "gettext" => :build
  end

  def install
    # The switches are explicit: auto would follow whatever happens to be on the
    # runner. json-glib gives the language servers, the debug adapters and the
    # queries; the unit tests need check and are not part of the formula.
    args = %w[
      -Dscreen=slang
      -Dlua=enabled
      -Ddap=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluerig --version")
    assert_match version.to_s, shell_output("#{bin}/brg --version")
  end
end

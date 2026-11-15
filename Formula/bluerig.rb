class Bluerig < Formula
  desc "Terminal IDE, a continuation of cooledit"
  homepage "https://github.com/blue-panels/bluerig"
  url "https://github.com/blue-panels/bluerig/releases/download/bluerig-1.0.1/bluerig-1.0.1.tar.gz"
  sha256 "8b3688ee271f082e0d6c9e788d12211ed40556bc5e8d1e7d96292d3e2557c301"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^bluerig[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/blue-panels/tap"
    sha256 arm64_tahoe:  "41ec7c64d230cee4bd7f71d1475f036dedf78ac9860c3e805b738312667eacc5"
    sha256 x86_64_linux: "bfcd7f41af15c4a5d125ffe1cef6563ed60ab733f2e630c717909437505af67a"
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

    # meson writes the interpreters it found into the syntax file, and under
    # Homebrew on macOS those are the shims rather than the real binaries.
    inreplace pkgshare/"syntax/Syntax", Superenv.shims_path.to_s, "/usr/bin",
              audit_result: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluerig --version")
  end
end

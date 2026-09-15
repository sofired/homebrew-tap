class Composemux < Formula
  desc "Read-only terminal UI for Docker Compose logs with pinnable panes"
  homepage "https://github.com/sofired/composemux"
  url "https://github.com/sofired/composemux/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6025839fca71a44ff2c56a2e6fc4f9b05d0354c1cd290262588fb04f85616156"
  license "MIT"

  head "https://github.com/sofired/composemux.git", branch: "main"

  bottle do
    root_url "https://github.com/sofired/homebrew-tap/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c3c04950bc7c2b3534ee2d2c336730814b688e232c4a9052c147cbffcc09d51"
    sha256 cellar: :any,                 arm64_linux:   "e491106bb642172a3404e057880090b7f488d7a4cafed9f6668d3ddb6684c077"
    sha256 cellar: :any,                 x86_64_linux:  "9978564366b1705a99478dcbee7c1115b0aab0d8c7d9f1bbca94654befaec67c"
  end

  # rust is build-only: the tap's CI (.github/workflows/tests.yml and
  # publish.yml) builds and publishes bottles for this formula, so a normal
  # `brew install` downloads a prebuilt binary rather than compiling.
  depends_on "rust" => :build

  # cargo fetches crates.io deps during the build; Homebrew's build sandbox
  # allows network by default (opt out with deny_network_access!), so no
  # allow_network_access! stanza is needed.
  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "composemux #{version}", shell_output("#{bin}/composemux --version")
  end
end

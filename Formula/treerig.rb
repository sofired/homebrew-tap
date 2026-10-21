class Treerig < Formula
  desc "Give every Git worktree a durable identity, an isolated home, and a routed URL"
  homepage "https://github.com/sofired/treerig"
  url "https://github.com/sofired/treerig/releases/download/v0.1.0/treerig-0.1.0.tar.gz"
  sha256 "db7c44ad84bd32ae362854b36eed74a08b9459d29cd6a0c37cee33cd40f095fb"
  license "Apache-2.0"

  head "https://github.com/sofired/treerig.git", branch: "main"

  bottle do
    root_url "https://github.com/sofired/homebrew-tap/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d32b4dabea2cc2c97ea7bd54522ccc1b144165820d87fff5f7412dfd2b3e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450bbf0872f4654a4a332a636acdc0fac7712b3c6b00809a6737c052d6da08d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bcf84b621ddff3ca7e540ec156ec316da60e4aa028db0c803a7b11f3001b03"
  end

  # go is build-only: the tap's CI builds and publishes bottles for this
  # formula, so a normal `brew install` downloads a prebuilt binary rather than
  # compiling.
  depends_on "go" => :build

  def install
    # Releases never link cgo.
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/sofired/treerig/internal/brand.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/treerig"
    generate_completions_from_executable(bin/"treerig", "completion")
    # `trig` is a short alias: the same binary under a second name, which
    # prints and completes as `trig` when run that way (brand.CLIName follows
    # argv[0]). Its completions come from running it under that name.
    bin.install_symlink "treerig" => "trig"
    generate_completions_from_executable(bin/"trig", "completion", base_name: "trig")
  end

  def caveats
    <<~EOS
      treerig needs Git, Docker and Docker Compose at run time.
      `treerig doctor` checks all three.

      `trig` is the same program under a shorter name.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treerig --version")
    assert_match "_treerig", shell_output("#{bin}/treerig completion bash")
    assert_match version.to_s, shell_output("#{bin}/trig --version")
    assert_match "_trig", shell_output("#{bin}/trig completion bash")
    assert_predicate bin/"trig", :symlink?
  end
end

class Killnode < Formula
  desc "A fast, interactive TUI for finding and deleting node_modules directories"
  homepage "https://github.com/shacript/killnode"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/killnode/releases/download/v0.1.0/killnode-aarch64-apple-darwin.tar.xz"
      sha256 "b2b276d781899a2c295bf08d18d66cd728df40651d5194a99665621a8afc4bd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/killnode/releases/download/v0.1.0/killnode-x86_64-apple-darwin.tar.xz"
      sha256 "a9ca4b492c0fcb0249a5905a5c36fcd8a2d0c5682c3762e20a1c5d948c59d26e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/killnode/releases/download/v0.1.0/killnode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40b35c3c207e611c50c17d2459936ba52e886381272538bbe7e75c9b3f93119f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/killnode/releases/download/v0.1.0/killnode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5541d767a377a24e4a973529ba554622e712ac6b04a7a1eb13c91d2964e892cb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "killnode" if OS.mac? && Hardware::CPU.arm?
    bin.install "killnode" if OS.mac? && Hardware::CPU.intel?
    bin.install "killnode" if OS.linux? && Hardware::CPU.arm?
    bin.install "killnode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

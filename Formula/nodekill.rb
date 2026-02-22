class Nodekill < Formula
  desc "A fast, interactive TUI for finding and deleting node_modules directories"
  homepage "https://github.com/shacript/nodekill"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/nodekill/releases/download/v0.1.0/nodekill-aarch64-apple-darwin.tar.xz"
      sha256 "0f8070018cefa0ae577dba6d9f64b1da786ac5fd0ea67d4ed808b0017302e85d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/nodekill/releases/download/v0.1.0/nodekill-x86_64-apple-darwin.tar.xz"
      sha256 "c35389cdde9bbd7e3661b434405f37f329084a89d82ebff2397f3eab91488763"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/nodekill/releases/download/v0.1.0/nodekill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3c452dfdd9bb8cf4d39cf9876b5b0d7df927a516bd7e59cc543e292c754bee3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/nodekill/releases/download/v0.1.0/nodekill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c56525f20281d093b1e98b745b649fc4472b37cd7c61f3ffa13432a5728f12b"
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
    bin.install "nodekill" if OS.mac? && Hardware::CPU.arm?
    bin.install "nodekill" if OS.mac? && Hardware::CPU.intel?
    bin.install "nodekill" if OS.linux? && Hardware::CPU.arm?
    bin.install "nodekill" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

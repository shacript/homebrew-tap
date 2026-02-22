class Nodenuke < Formula
  desc "A fast, interactive TUI for finding and deleting node_modules directories"
  homepage "https://github.com/shacript/nodenuke"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/nodenuke/releases/download/v0.1.0/nodenuke-aarch64-apple-darwin.tar.xz"
      sha256 "77d91a207e07248f0d7a97810e746a488bd78c547bb7c1c21998532659f51995"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/nodenuke/releases/download/v0.1.0/nodenuke-x86_64-apple-darwin.tar.xz"
      sha256 "972de37120c0c9f2d69ee5bc642a722bba8c170807846e5630dfe9fd6d4ae1cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shacript/nodenuke/releases/download/v0.1.0/nodenuke-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3b668af8ddd344bd8643ab2c606f73fe1de12f268e079716c658b9d024d2384"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shacript/nodenuke/releases/download/v0.1.0/nodenuke-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6997a1f0a8c97f71830bdfa20b57893e63227ad2646b00a0a5605569b95d1986"
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
    bin.install "nodenuke" if OS.mac? && Hardware::CPU.arm?
    bin.install "nodenuke" if OS.mac? && Hardware::CPU.intel?
    bin.install "nodenuke" if OS.linux? && Hardware::CPU.arm?
    bin.install "nodenuke" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

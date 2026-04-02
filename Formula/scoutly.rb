class Scoutly < Formula
  desc "A fast, lightweight CLI website crawler and SEO analyzer built with Rust."
  homepage "https://github.com/nelsonlaidev/scoutly"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.3.0/scoutly-aarch64-apple-darwin.tar.xz"
      sha256 "cd8f439cf2c38ca1c7a56df958aace2f69be1257d19cecd298cd292bf123d832"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.3.0/scoutly-x86_64-apple-darwin.tar.xz"
      sha256 "6ff95785aa2c43586eb433c690ccd9daa000385ec8baba41335b97b0ea58bc0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.3.0/scoutly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7a2a084bfa8363c93e49313c2a7e96e92793da70d0bea5821764446f3c86dc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.3.0/scoutly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9d41a3f7fb26dfccd9e1f9a895c6865d0b126d274f6e68a5eaa838e288df9c6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "scoutly" if OS.mac? && Hardware::CPU.arm?
    bin.install "scoutly" if OS.mac? && Hardware::CPU.intel?
    bin.install "scoutly" if OS.linux? && Hardware::CPU.arm?
    bin.install "scoutly" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

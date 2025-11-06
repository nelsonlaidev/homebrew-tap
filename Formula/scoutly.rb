class Scoutly < Formula
  desc "A fast, lightweight CLI website crawler and SEO analyzer built with Rust."
  homepage "https://github.com/nelsonlaidev/scoutly"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-aarch64-apple-darwin.tar.xz"
      sha256 "17cba5525943a401cd259173bf0d9cea60559a13f2239916672e1b66da63d0a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-x86_64-apple-darwin.tar.xz"
      sha256 "401dc6be4e06279a9042b5cb41c262a6a9c3789b7b3affb0a6e6de4b0e96f996"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "121b610cb183a7f5835781bd47220e6c5acebac197ce3b5a2fe3b18ac8b64dca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36c02729cad2f418dedc93112724048f9d76879290c88da4f5f15b182c50e508"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-unknown-linux-gnu":              {},
    "aarch64-unknown-linux-musl-dynamic":     {},
    "aarch64-unknown-linux-musl-static":      {},
    "arm-unknown-linux-gnueabihf":            {},
    "arm-unknown-linux-musl-dynamiceabihf":   {},
    "arm-unknown-linux-musl-staticeabihf":    {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
    "i686-pc-windows-gnu":                    {},
    "i686-unknown-linux-gnu":                 {},
    "i686-unknown-linux-musl-dynamic":        {},
    "i686-unknown-linux-musl-static":         {},
    "powerpc64-unknown-linux-gnu":            {},
    "powerpc64le-unknown-linux-gnu":          {},
    "riscv64gc-unknown-linux-gnu":            {},
    "s390x-unknown-linux-gnu":                {},
    "x86_64-apple-darwin":                    {},
    "x86_64-pc-windows-gnu":                  {},
    "x86_64-unknown-linux-gnu":               {},
    "x86_64-unknown-linux-musl-dynamic":      {},
    "x86_64-unknown-linux-musl-static":       {},
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

class Scoutly < Formula
  desc "A fast, lightweight CLI website crawler and SEO analyzer built with Rust."
  homepage "https://github.com/nelsonlaidev/scoutly"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-aarch64-apple-darwin.tar.xz"
      sha256 "696ec9b989afbd141d1803e22d2e0cbb9ff181af250508ca8744439906cb38bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-x86_64-apple-darwin.tar.xz"
      sha256 "54b383fef9c60d17ba8f65f910018d3797e21d5c16a6017d32f217ec9f929770"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7edb3d6b267f4053737288b29cbe6c1093b6695805e32e21b9b572619ab34ee7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.1.0/scoutly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c721fa238f765d4f8b04e205ce3a9ef2962c46ba38b3f13818cc5188f4d8e978"
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

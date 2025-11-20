class Scoutly < Formula
  desc "A fast, lightweight CLI website crawler and SEO analyzer built with Rust."
  homepage "https://github.com/nelsonlaidev/scoutly"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.2.0/scoutly-aarch64-apple-darwin.tar.xz"
      sha256 "23a00113df2f880d5f07f26ed0c74bf500240d839a901eac19d665ed4f5b6cc9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.2.0/scoutly-x86_64-apple-darwin.tar.xz"
      sha256 "ad71060b202d0db6c139e52dfd910c79df713e1222198fa25cfb3f0a3eae7b97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.2.0/scoutly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75d394a4ef871de37e8306ca24a0c1a8a2937c7cc9b937e774fa324e91dd5678"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.2.0/scoutly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41e5b571ca2e5c5285004974c2cb14a50912eb61b04f8380a6f97b0f950f7dfa"
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

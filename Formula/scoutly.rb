class Scoutly < Formula
  desc "A fast, lightweight CLI website crawler and SEO analyzer built with Rust."
  homepage "https://github.com/nelsonlaidev/scoutly"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.4.0/scoutly-aarch64-apple-darwin.tar.xz"
      sha256 "0f98bc3837b49f96d78d8e09838933a8d7e203e3d89062a5b1fa7260998955f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.4.0/scoutly-x86_64-apple-darwin.tar.xz"
      sha256 "59b2284a23046ca795df843244ab420e47dad707ee629fe8bfc70cf597446139"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.4.0/scoutly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0ff8995e2a70eb1567bb159c064199383996790f57bf718554b38064b3d919c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nelsonlaidev/scoutly/releases/download/v0.4.0/scoutly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "711289cb90a656f380e54173d1e2170fd53825a520e2817c85bbce4766846e7a"
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

#!/usr/bin/env bash
# Rewrite Formula/supaforge.rb for a published @akal/supaforge version: the
# npm tarball and its SHA-256.
#
#   scripts/update-formula.sh 0.0.33
set -euo pipefail

version="${1:?usage: $0 <version>   e.g. 0.0.33}"
url="https://registry.npmjs.org/@akal/supaforge/-/supaforge-${version}.tgz"
cd "$(dirname "$0")/.."

sum="$(curl -fsSL "$url" | sha256sum | cut -d' ' -f1)"
[ ${#sum} -eq 64 ] || { echo "could not download $url" >&2; exit 1; }

cat > Formula/supaforge.rb <<RUBY
# Written by scripts/update-formula.sh — edit that, not this.
class Supaforge < Formula
  desc "Find and fix drift between Supabase environments"
  homepage "https://supaforge.dev"
  url "${url}"
  sha256 "${sum}"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "supaforge/#{version}", shell_output("#{bin}/supaforge --version")
    # Its DBDiff engine, a native binary per platform, came with it.
    assert_match "drift", shell_output("#{bin}/supaforge diff --help")
  end
end
RUBY
echo "Formula/supaforge.rb → ${version}"

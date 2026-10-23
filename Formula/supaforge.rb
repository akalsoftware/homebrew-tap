# Written by scripts/update-formula.sh — edit that, not this.
class Supaforge < Formula
  desc "Find and fix drift between Supabase environments"
  homepage "https://supaforge.dev"
  url "https://registry.npmjs.org/@akal/supaforge/-/supaforge-0.0.38.tgz"
  sha256 "0d0c9c4a69a5c3faa211f05dde4bc6169dcb7a1bcd578057554332089ebd86e2"
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

# Written by scripts/update-formula.sh — edit that, not this.
class Supaforge < Formula
  desc "Find and fix drift between Supabase environments"
  homepage "https://supaforge.dev"
  url "https://registry.npmjs.org/@akal/supaforge/-/supaforge-0.0.50.tgz"
  sha256 "df68f818a972c64c0e1abd20fa0d9968d07f0291318e88793b6da3fbacd8e944"
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

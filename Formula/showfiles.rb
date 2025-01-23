class Showfiles < Formula
    desc "Show the content of directories and files with syntax highlighting"
    homepage "https://github.com/integrateLuis/homebrew-showfiles"
    url "https://github.com/integrateLuis/homebrew-showfiles/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    license "MIT"
  
    def install
      bin.install "show_files.sh" => "showfiles"
    end
  
    test do
      system "#{bin}/showfiles", "--help"
    end
  end
  
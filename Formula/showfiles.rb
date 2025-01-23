class Showfiles < Formula
    desc "Show the content of directories and files with syntax highlighting"
    homepage "https://github.com/integrateLuis/homebrew-showfiles"
    url "https://github.com/integrateLuis/homebrew-showfiles/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "dc165c63e985624716a487927d5d73f773be21bfffc05e54f5d2fe728d3d7fb7"
    license "MIT"
  
    def install
      bin.install "show_files.sh" => "showfiles"
    end
  
    test do
      system "#{bin}/showfiles", "--help"
    end
  end
  
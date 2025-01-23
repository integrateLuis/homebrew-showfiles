class Showfiles < Formula
    desc "Show the content of directories and files with syntax highlighting"
    homepage "https://github.com/integrateLuis/homebrew-showfiles"
    url "https://github.com/integrateLuis/homebrew-showfiles/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "PON_EL_SHA256_CORRECTO_AQUI"
    license "MIT"
  
    def install
      bin.install "show_files.sh" => "showfiles"
    end
  
    test do
      system "#{bin}/showfiles", "--help"
    end
  end
  
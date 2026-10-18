cask "uets-eimza" do
  version "2026.10.18"
  sha256 "a6a6f315f4c01b33dc6d80a98b709154b1be5c24de9b1e79425e7d5ac092f0ab"

  url "https://github.com/adeministratorr/uets-eimza-mac-arm64/releases/download/v#{version}/UetsEimza-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/uets-eimza-mac-arm64/"
  name "PTT UETS E-İmza"
  desc "UETS (e-Tebligat) e-imza uygulaması (arm64; kaynaktan derlenmiş)"
  homepage "https://github.com/adeministratorr/uets-eimza-mac-arm64"

  depends_on arch: :arm64

  app "PTT UETS E-İmza.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/PTT UETS E-İmza.app"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      Bu uygulama YALNIZCA UETS (e-Tebligat) işlem kodları içindir.
      PTT KEP Webmail için ayrı uygulama gerekir: pttkep-eimza.
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir.
    EOS
  end
end

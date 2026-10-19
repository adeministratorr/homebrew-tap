cask "edevlet-eimza" do
  version "2026.10.18"
  sha256 "930a540ff4550f035db09d96a9dcc230d6168c0b5c4e6da3166228f27d5453e4"

  url "https://github.com/adeministratorr/edevlet-eimza-mac-arm64/releases/download/v#{version}/EdevletEimza-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/edevlet-eimza-mac-arm64/"
  name "E-Devlet E-İmza"
  desc "e-Devlet e-imza uygulaması (arm64; kaynaktan derlenmiş, patch_jar düzeltmeli)"
  homepage "https://github.com/adeministratorr/edevlet-eimza-mac-arm64"

  depends_on arch: :arm64

  app "E-Devlet E-İmza.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/E-Devlet E-İmza.app"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir:
        https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
      İlk açılışta "geliştirici doğrulanamadı" uyarısı çıkarsa: sağ tık -> Aç.
    EOS
  end
end

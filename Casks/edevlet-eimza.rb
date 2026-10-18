cask "edevlet-eimza" do
  version "2026.10.18"
  sha256 "6f2d6736fe2ef6159bfb93377a9c2929a952d4fb52282972b5acef3ffff58eea"

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

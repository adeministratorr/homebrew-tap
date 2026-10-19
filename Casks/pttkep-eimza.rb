cask "pttkep-eimza" do
  version "2026.10.18"
  sha256 "07ff8103ed44be0188b9616a5b0ae505a71abf3573c6688eb40226e8507be1e3"

  url "https://github.com/adeministratorr/pttkep-eimza-mac-arm64/releases/download/v#{version}/PttkepEimza-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/pttkep-eimza-mac-arm64/"
  name "PTT KEP E-İmza"
  desc "PTT KEP Webmail e-imza uygulaması (arm64; kaynaktan derlenmiş)"
  homepage "https://github.com/adeministratorr/pttkep-eimza-mac-arm64"

  depends_on arch: :arm64

  app "PTT KEP E-İmza.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/PTT KEP E-İmza.app"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      jnlp.config otomatik gömülür: https://ptt.hs01.kep.tr/download/config.properties
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir.
      UETS (e-Tebligat) için ayrı uygulama gerekir: uets-eimza.
    EOS
  end
end

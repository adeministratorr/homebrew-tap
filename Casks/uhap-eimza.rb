cask "uhap-eimza" do
  version "2026.10.19"
  sha256 "74f580911e4ca2e7e7a32809c85576871b638df2aaceaed9a60313afec2b3564"

  url "https://github.com/adeministratorr/uhap-eimza-mac-arm64/releases/download/v#{version}/UhapEimza-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/uhap-eimza-mac-arm64/"
  name "UHAP İmzalama"
  desc "UHAP e-imza uygulaması (arm64; kaynaktan derlenmiş)"
  homepage "https://github.com/adeministratorr/uhap-eimza-mac-arm64"

  depends_on arch: :arm64

  app "UHAPImza.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/UHAPImza.app"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      MODE=cmk (UHAP-CMK; port 5085) desteği için kur.sh veya formül yolunu kullanın.
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir:
        https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
    EOS
  end
end

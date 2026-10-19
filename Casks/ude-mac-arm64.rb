cask "ude-mac-arm64" do
  version "2026.10.18"
  sha256 "3108d8bead26eb64f2edf1774b50e519049e0cd1ca037200436f655458af8824"

  url "https://github.com/adeministratorr/ude-mac-arm64-1/releases/download/v#{version}/UdeMacArm64-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/ude-mac-arm64-1/"
  name "UYAP Doküman Editörü"
  desc "UYAP Doküman Editörü (arm64; resmi paketin topluluk uzantısı)"
  homepage "https://github.com/adeministratorr/ude-mac-arm64-1"

  depends_on arch: :arm64

  app "Uyap Doküman Editörü.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Uyap Doküman Editörü.app"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      Eski Intel kopyaları varsa silin. Açılmazsa ~/.uki klasörünü temizleyin.
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir.
    EOS
  end
end

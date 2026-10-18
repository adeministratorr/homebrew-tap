cask "tnb-eimza" do
  version "2026.10.18"
  sha256 "25e865051b7f90d0711992ead6c600e3cd5134ad28169682c2aa0418903f7954"

  url "https://github.com/adeministratorr/tnb-eimza-mac-arm64/releases/download/v#{version}/TnbEimza-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/tnb-eimza-mac-arm64/"
  name "TNB Teknoloji İmza"
  desc "TNB kep.hs02.kep.tr e-imza uygulaması (arm64; kaynaktan derlenmiş)"
  homepage "https://github.com/adeministratorr/tnb-eimza-mac-arm64"

  depends_on arch: :arm64

  app "TNBTeknolojiImza.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/TNBTeknolojiImza.app"], must_succeed: false

    host_json = <<~JSON
      {
        "name": "tnbtimzahost",
        "description": "TnbTeknoloji Imza Chrome Native Messaging Host (macOS arm64)",
        "path": "/Applications/TNBTeknolojiImza.app/Contents/MacOS/TNBTeknolojiImza",
        "type": "stdio",
        "allowed_origins": [
          "chrome-extension://ppgjmopocehhllbjblnpdajkkkfghpan/"
        ]
      }
    JSON
    browsers = [
      "Google/Chrome", "Google/Chrome Beta", "Google/Chrome Dev", "Google/Chrome Canary",
      "Chromium", "Microsoft Edge", "BraveSoftware/Brave-Browser", "Vivaldi",
      "Yandex/YandexBrowser", "com.operasoftware.Opera",
    ]
    support = File.expand_path("~/Library/Application Support")
    browsers.each do |browser|
      dir = "#{support}/#{browser}"
      next unless File.directory?(dir)

      nm = "#{dir}/NativeMessagingHosts"
      begin
        FileUtils.mkdir_p(nm)
        File.write("#{nm}/tnbtimzahost.json", host_json)
      rescue SystemCallError
        nil
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/Google/Chrome/NativeMessagingHosts/tnbtimzahost.json",
    "~/Library/Application Support/Chromium/NativeMessagingHosts/tnbtimzahost.json",
    "~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/tnbtimzahost.json",
    "~/Library/Application Support/com.operasoftware.Opera/NativeMessagingHosts/tnbtimzahost.json",
  ]

  caveats do
    puts <<~EOS
      Chrome eklentisi: https://chromewebstore.google.com/detail/ppgjmopocehhllbjblnpdajkkkfghpan
      Tarayıcı kaydı yukarıda otomatik yapılmaya çalışılır; kayıt olmazsa bir kez:
        brew install adeministratorr/tap/tnb-eimza && eimza-install-tnb
      Kayıt sonrası Chrome'u TAMAMEN kapatıp açın. Giriş: https://kep.hs02.kep.tr
      e-imza için TÜBİTAK AKİS arm64 sürücüsü gerekir.
    EOS
  end
end

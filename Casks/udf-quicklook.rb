cask "udf-quicklook" do
  version "2026.10.19"
  sha256 "4d39ee50f2399fcd3b848c2ecd99738df78576caf8680edce246f8e5ee97f43c"

  url "https://github.com/adeministratorr/udf-quicklook-extension/releases/download/v#{version}/UdfQuicklook-arm64-#{version}.dmg",
      verified: "github.com/adeministratorr/udf-quicklook-extension/"
  name "UDFViewer (UYAP QuickLook)"
  desc "UDF (UYAP) dosyaları için QuickLook önizleme (arm64)"
  homepage "https://github.com/adeministratorr/udf-quicklook-extension"

  depends_on arch: :arm64

  app "UDFViewer.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/UDFViewer.app"], must_succeed: false
    %w[QuickLookPreview QuickLookThumbnail].each do |name|
      system_command "/usr/bin/pluginkit",
                     args:         ["-a", "#{appdir}/UDFViewer.app/Contents/PlugIns/#{name}.appex"],
                     must_succeed: false
    end
    system_command "/usr/bin/pluginkit", args: ["-e", "use", "-i", "com.uyapudf.viewer.QuickLookPreview"], must_succeed: false
    system_command "/usr/bin/pluginkit", args: ["-e", "use", "-i", "com.uyapudf.viewer.QuickLookThumbnail"], must_succeed: false
  end

  caveats do
    puts <<~EOS
      Finder'da .udf dosyası seçiliyken boşluk tuşu ile önizleme açılır.
      Önizleme görünmüyorsa: Sistem Ayarları -> Giriş Öğeleri ve Uzantılar ->
      Hızlı Bakış -> "UDFViewer" işaretli olmalı.
    EOS
  end
end

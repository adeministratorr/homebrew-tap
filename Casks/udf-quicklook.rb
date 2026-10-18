cask "udf-quicklook" do
  version "2026.10.18"
  sha256 "c84dce67d1d6b160bb02fc9037a2437bba9b2d94dba65b6b952e15f580c68e86"

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

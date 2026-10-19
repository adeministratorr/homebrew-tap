cask "udf-quicklook" do
  version "2026.10.19"
  sha256 "b4e44859c4d6d3a77ba353a28f2386d0b8f57b04242ec85305f52711eeda4eb3"

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

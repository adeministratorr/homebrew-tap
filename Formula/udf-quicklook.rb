class UdfQuicklook < Formula
  desc "UDF (UYAP) dosyalari icin QuickLook onizleme - UDFViewer.app + Preview/Thumbnail eklentileri"
  homepage "https://github.com/adeministratorr/udf-quicklook-extension"
  version "2026.10.19"
  url "https://github.com/adeministratorr/udf-quicklook-extension/archive/refs/heads/main.tar.gz"
  sha256 "bbfe7171766a364636e9470f86ed83ccd390d73c25916b9e37ef52460069d134"

  def install
    # brew 6+ derleme sandbox'i icinde SwiftPM'in kendi manifest sandbox'i
    # (sandbox-exec) ic ice acilamaz: "sandbox_apply: Operation not permitted".
    # SwiftPM'in ic sandbox'unu kapat; brew'in sandbox'u korumayi surdurur.
    inreplace "scripts/build.sh", "swift build -c release",
              "swift build -c release --disable-sandbox"
    system "bash", "scripts/build.sh"
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    app_file = File.basename(apps.first)
    FileUtils.cp_r apps.first, prefix
    (bin/"eimza-install-udf").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "UDFViewer" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      codesign --force -s - --deep "$DEST" 2>/dev/null || true
      LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
      "$LSREGISTER" -f "$DEST" 2>/dev/null || true
      pluginkit -a "$DEST/Contents/PlugIns/QuickLookPreview.appex" 2>/dev/null || true
      pluginkit -a "$DEST/Contents/PlugIns/QuickLookThumbnail.appex" 2>/dev/null || true
      pluginkit -e use -i com.uyapudf.viewer.QuickLookPreview 2>/dev/null || true
      pluginkit -e use -i com.uyapudf.viewer.QuickLookThumbnail 2>/dev/null || true
      qlmanage -r cache >/dev/null 2>&1 || true
      open -g "$DEST" 2>/dev/null || true
    EOS
    chmod 0755, bin/"eimza-install-udf"
  end

  def caveats
    <<~EOS
      Kurulumdan sonra /Applications'a yerlestirmek icin:
        eimza-install-udf

      Finder'da .udf dosyasi icin bosluk (space) ile onizleme acilir.
      Onizleme gorunmuyorsa: Sistem Ayarlari -> Giris Ogeleri ve Uzantilar ->
      Hizli Bakis -> "UDFViewer" isaretli olmali.
    EOS
  end
end

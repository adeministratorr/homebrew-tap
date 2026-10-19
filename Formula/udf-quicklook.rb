class UdfQuicklook < Formula
  desc "UDF (UYAP) dosyalari icin QuickLook onizleme - UDFViewer.app + Preview/Thumbnail eklentileri"
  homepage "https://github.com/adeministratorr/udf-quicklook-extension"
  version "2026.10.19"
  url "https://github.com/adeministratorr/udf-quicklook-extension/archive/refs/heads/main.tar.gz"
  sha256 "fb34e5891c5e883b90596e326589f22cc12ac2dbe39fec3e913135a37044d0b5"

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
      if ! codesign --verify --deep "$DEST" >/dev/null 2>&1; then
        for x in "$DEST/Contents/PlugIns"/*.appex; do
          [ -e "$x" ] && codesign --force -s - --preserve-metadata=entitlements "$x" 2>/dev/null || true
        done
        codesign --force -s - --preserve-metadata=entitlements "$DEST" 2>/dev/null || true
      fi
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

  def post_install
    # brew'ın kurulum sonrası linkage düzeltmesi paket dosyalarına dokunup
    # uygulama mührünü (CodeResources) bozabilir; keg kopyası relocation
    # SONRASI yeniden imzalanmazsa QuickLook appex'leri geçersiz imzayla
    # kalır ve pluginkit sessizce reddeder. appex'ler ve uygulama ayrı ayrı,
    # entitlement'lar (app-sandbox) korunarak imzalanır.
    Dir.glob("#{prefix}/*.app").each do |a|
      Dir.glob("#{a}/Contents/PlugIns/*.appex").each do |x|
        system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", x
      end
      system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", a
    end
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

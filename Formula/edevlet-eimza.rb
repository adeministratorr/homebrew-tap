class EdevletEimza < Formula
  desc "e-Devlet E-Imza (Turksat): resmi jar'i indirip jpackage ile arm64 .app uretir (Zulu 11 goemulu, saidsurucu tabanli fix surum)"
  homepage "https://github.com/adeministratorr/edevlet-eimza-mac-arm64"
  version "2026.10.18"
  url "https://github.com/adeministratorr/edevlet-eimza-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "031f2b8670e2db284bd97bd7926dd007cc0f3ee139a0a7d2421f57283f9e431b"

  preserve_rpath

  def install
    odie "Bu formul yalnizca Apple Silicon (arm64) icindir." unless Hardware::CPU.arm?
    system "bash", "scripts/build.sh", "jdk"
    system "bash", "scripts/build.sh", "jpackage-jdk"
    system "bash", "scripts/build.sh", "all"
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    app_file = File.basename(apps.first)
    FileUtils.cp_r apps.first, prefix
    (bin/"eimza-install-edevlet").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "E-Devlet E-İmza" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      if ! codesign --verify --deep "$DEST" >/dev/null 2>&1; then
        for x in "$DEST/Contents/PlugIns"/*.appex; do
          [ -e "$x" ] && codesign --force -s - --preserve-metadata=entitlements "$x" 2>/dev/null || true
        done
        codesign --force -s - --preserve-metadata=entitlements "$DEST" 2>/dev/null || true
      fi
      echo "Açmak için Launchpad'den açın veya:"
      echo "  open \"$DEST\""
    EOS
    chmod 0755, bin/"eimza-install-edevlet"
  end

  def post_install
    # brew'ın kurulum sonrası linkage düzeltmesi paket dosyalarına dokunup
    # uygulama mührünü (CodeResources) bozabilir; keg kopyası relocation
    # SONRASI yeniden imzalanmazsa çalışma anında "Code Signature Invalid"
    # ile öldürülebilir. appex'ler ve uygulama ayrı ayrı, entitlement'lar
    # korunarak imzalanır (codesign --deep standart dışı konumları kapsamaz).
    Dir.glob("#{prefix}/*.app").each do |a|
      Dir.glob("#{a}/Contents/PlugIns/*.appex").each do |x|
        system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", x
      end
      system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", a
    end
  end

  def caveats
    <<~EOS
      Bu formul kaynak koddan uretilir (Zulu 11 gomulu).
      Homebrew /Applications'a yazamadigindan uygulama keg'de kalir;
      kurulumdan sonra asagidaki komutu calistirin:

        eimza-install-edevlet

      e-imza icin TÜBİTAK AKİS arm64 (Apple Silicon) surucusu ayrica kurun:
        https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
      Uygulama icinde PKCS#11 modulu: "Tubitak AKIS".
      Ilk acilista "dev gelistirici" uyarisi: sag tik -> Ac.
    EOS
  end
end

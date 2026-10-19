class UetsEimza < Formula
  desc "PTT UETS E-Imza (e-Tebligat): resmi jar'i indirip jpackage ile arm64 .app uretir (Zulu 11 goemulu)"
  homepage "https://github.com/saidsurucu/uets-eimza-mac-arm64"
  version "2026.10.17"
  url "https://github.com/saidsurucu/uets-eimza-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "a9c406abb5a38f47398778c89710286c1604689f8d8efbe7a5c1ef1b7608c971"

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
    (bin/"eimza-install-uets").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "PTT UETS E-İmza" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      if ! codesign --verify --deep "$DEST" >/dev/null 2>&1; then
        for x in "$DEST/Contents/PlugIns"/*.appex; do
          [ -e "$x" ] && codesign --force -s - --preserve-metadata=entitlements "$x" 2>/dev/null || true
        done
        codesign --force -s - --preserve-metadata=entitlements "$DEST" 2>/dev/null || true
      fi
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-uets"
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
      Kurulumdan sonra /Applications'a yerlestirmek icin:
        eimza-install-uets

      jnlp.config otomatik goemulur:
        https://api.etebligat.gov.tr/v1/auth/_eimza/
      AKIS arm64 surucusu: https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
    EOS
  end
end

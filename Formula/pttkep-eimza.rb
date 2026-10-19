class PttkepEimza < Formula
  desc "PTT KEP E-Imza: resmi jar'i indirip jpackage ile arm64 .app uretir (Zulu 11 goemulu)"
  homepage "https://github.com/saidsurucu/pttkep-eimza-mac-arm64"
  version "2026.10.17"
  url "https://github.com/saidsurucu/pttkep-eimza-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "9b2d348c256d4c648319c8dd9d7c58bcc923f0c07a63c5a498ffd63d5ab5a4a6"

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
    (bin/"eimza-install-pttkep").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "PTT KEP E-İmza" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      codesign --force -s - --deep "$DEST" 2>/dev/null || true
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-pttkep"
  end

  def caveats
    <<~EOS
      Kurulumdan sonra /Applications'a yerlestirmek icin:
        eimza-install-pttkep

      jnlp.config otomatik goemulur:
        https://ptt.hs01.kep.tr/download/config.properties
      AKIS arm64 surucusu: https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
    EOS
  end
end

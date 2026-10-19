class UdeMacArm64 < Formula
  desc "Uyap Dokuman Editoru kaynaktan arm64 build (Java 11, PCSC duzeltmesi, zoom yamalari)"
  homepage "https://github.com/saidsurucu/ude-mac-arm64"
  version "2026.10.17"
  url "https://github.com/saidsurucu/ude-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "3133935fae2bc1b2dd1cfe408a981acf872d2cfe414b89d36f335020b0d5fc28"

  preserve_rpath

  def install
    system "make", "jdk"
    system "make", "jpackage-jdk"
    system "make", "all"
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    app_file = File.basename(apps.first)
    FileUtils.cp_r apps.first, prefix
    (bin/"eimza-install-ude").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "Uyap Doküman Editörü" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      codesign --force -s - --deep "$DEST" 2>/dev/null || true
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-ude"
  end

  def caveats
    <<~EOS
      Kurulumdan sonra /Applications'a yerlestirmek icin:
        eimza-install-ude

      Resmi Apple Silicon paketinin uzantisi/kalite surumu:
        https://github.com/saidsurucu/ude-mac-arm64
      Ozellikler: keskin metin (Java 11), e-imza PCSC duzeltmesi (5.4.17_4+),
      native dosya pencereleri, .udf dosya iliskisi.
    EOS
  end
end

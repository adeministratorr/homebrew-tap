class UhapEimza < Formula
  desc "UHAP Imzalama: make ile arm64 .app uretir, AKIS surucusunu Java Extensions'a yerlestirir"
  homepage "https://github.com/saidsurucu/uhap-eimza-mac-arm64"
  version "2026.10.17"
  url "https://github.com/saidsurucu/uhap-eimza-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "a62c3250369d86c4dee7feeec5001980a6456bfe40dd9487697f0e6dea9797be"

  preserve_rpath

  def install
    odie "Bu formul yalnizca Apple Silicon (arm64) icindir." unless Hardware::CPU.arm?
    icns = buildpath/"assets/UHAPImza.icns"
    unless icns.exist?
      begin
        system "bash", "scripts/make-icns.sh"
      rescue BuildError
        opoo "Ikon uretilemedi; devam ediliyor (kozmetik)."
      end
    end
    system "make", "app"
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    app_file = File.basename(apps.first)
    FileUtils.cp_r apps.first, prefix
    (bin/"eimza-install-uhap").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "UHAP İmzalama" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      codesign --force -s - --deep "$DEST" 2>/dev/null || true
      EXTDIR="$HOME/Library/Java/Extensions"
      TARGET="$EXTDIR/libakisp11.dylib"
      if [ ! -f "$TARGET" ] || ! lipo -archs "$TARGET" 2>/dev/null | grep -qw arm64; then
        for cand in /usr/local/lib/libakisp11.dylib /Library/Java/Extensions/libakisp11.dylib; do
          if [ -f "$cand" ] && lipo -archs "$cand" 2>/dev/null | grep -qw arm64; then
            mkdir -p "$EXTDIR"
            if [ -f "$TARGET" ]; then cp "$TARGET" "${TARGET}.x86_64.bak"; fi
            cp "$cand" "$TARGET"
            echo "arm64 AKIS surucusu yerlestirildi: $TARGET"
            break
          fi
        done
      fi
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-uhap"
  end

  def caveats
    <<~EOS
      Kurulumdan sonra /Applications'a yerlestirmek icin:
        eimza-install-uhap

      AKIS arm64 surucusu: https://akiskart.bilgem.tubitak.gov.tr/tr/destek/
      Ilk acilista "dev gelistirici" uyarisi: sag tik -> Ac.
    EOS
  end
end

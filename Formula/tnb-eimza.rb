class TnbEimza < Formula
  desc "TNB Teknoloji Imza: make ile arm64 .app uretir, Chrome host kaydini da destekler"
  homepage "https://github.com/saidsurucu/tnb-eimza-mac-arm64"
  version "2026.10.17"
  url "https://github.com/saidsurucu/tnb-eimza-mac-arm64/archive/refs/heads/main.tar.gz"
  sha256 "c6c2510d1c29c9240151172a0394d68af674867526af9916b167422799459f12"

  preserve_rpath

  def install
    odie "Bu formul yalnizca Apple Silicon (arm64) icindir." unless Hardware::CPU.arm?
    icns = buildpath/"assets/TNBTeknolojiImza.icns"
    unless icns.exist?
      begin
        system "bash", "scripts/make-icns.sh"
      rescue BuildError
        opoo "Ikon uretilemedi; devam ediliyor (kozmetik)."
      end
    end
    # brew derleme sandbox'inda AKIS dylib'i XPC hizmetine baglanamaz
    # (akisp11 Rust panigi: NoService) ve ShimTest SIGABRT ile olur.
    # Jar paketleme bu dogrulamadan bagimsizdir; sandbox altinda tolerliyoruz.
    inreplace "scripts/prep-payload.sh",
              %q{  -cp "$OUT_JAR:$WORK/patcher" ShimTest},
              %q{  -cp "$OUT_JAR:$WORK/patcher" ShimTest || echo "ShimTest atlandi (sandbox ortami)"}
    system "make", "app"
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    app_file = File.basename(apps.first)
    FileUtils.cp_r apps.first, prefix
    pkgshare.install "scripts/install-host.sh"
    (bin/"eimza-install-tnb").write <<~EOS
      #!/bin/bash
      set -eu
      APP="#{app_file}"
      SRC="#{opt_prefix}/#{app_file}"
      DEST="/Applications/${APP}"
      osascript -e 'tell application "TNB Teknoloji İmza" to quit' 2>/dev/null || true
      if [ -e "$DEST" ]; then rm -rf "$DEST"; fi
      ditto "$SRC" "$DEST"
      echo "Kuruldu: $DEST"
      if ! codesign --verify --deep "$DEST" >/dev/null 2>&1; then
        for x in "$DEST/Contents/PlugIns"/*.appex; do
          [ -e "$x" ] && codesign --force -s - --preserve-metadata=entitlements "$x" 2>/dev/null || true
        done
        codesign --force -s - --preserve-metadata=entitlements "$DEST" 2>/dev/null || true
      fi
      HOST="#{opt_prefix}/share/tnb-eimza/install-host.sh"
      if [ -x "$HOST" ]; then "$HOST" 2>/dev/null || true; fi
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-tnb"
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
        eimza-install-tnb

      Chrome eklentisi ayrica kurulmali:
        https://chromewebstore.google.com/detail/ppgjmopocehhllbjblnpdajkkkfghpan
      Kayit sonrasi Chrome'u TAMAMEN kapatip acin.
      Giris adresi: https://kep.hs02.kep.tr
      AKIS arm64 surucusu gerekir (Tubitak).
    EOS
  end
end

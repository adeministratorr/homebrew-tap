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
    # libnativedialogkeys derleyici tarafından mutlak geçici build yolu kimliğiyle
    # üretilir; brew'ın linkage düzeltmesi .app adındaki Türkçe karakterler (ö,ü)
    # yüzünden ruby-macho'da UTF-8 çökmesi yaşar. Kimliği @rpath yapıyoruz
    # (preserve_rpath korur); dosya çalışma anında MacTextKeys tarafından mutlak
    # yolla yüklendiğinden LC_ID değişimi davranışı etkilemez. install_name_tool
    # imzayı geçersiz kıldığından dylib'i ve uygulama mührünü yeniden imzalıyoruz
    # (Contents/app standart dışı konum olduğundan codesign --deep bu dylib'i
    #  kapsamaz; aksi halde dyld "Code Signature Invalid" ile uygulamayı öldürür).
    Dir.glob("#{buildpath}/build/*.app/Contents/app/libnativedialogkeys.dylib").each do |tk|
      system "install_name_tool", "-id", "@rpath/libnativedialogkeys.dylib", tk
      system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", tk
    end
    apps = Dir.glob("#{buildpath}/build/*.app").sort
    odie "Uygulama uretilemedi (build/ bos)." if apps.empty?
    apps.each { |a| system "codesign", "--force", "-s", "-", "--preserve-metadata=entitlements", a }
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
      if ! codesign --verify --deep "$DEST" >/dev/null 2>&1; then
        for x in "$DEST/Contents/PlugIns"/*.appex; do
          [ -e "$x" ] && codesign --force -s - --preserve-metadata=entitlements "$x" 2>/dev/null || true
        done
        codesign --force -s - --preserve-metadata=entitlements "$DEST" 2>/dev/null || true
      fi
      echo "open: $DEST"
    EOS
    chmod 0755, bin/"eimza-install-ude"
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
        eimza-install-ude

      Resmi Apple Silicon paketinin uzantisi/kalite surumu:
        https://github.com/saidsurucu/ude-mac-arm64
      Ozellikler: keskin metin (Java 11), e-imza PCSC duzeltmesi (5.4.17_4+),
      native dosya pencereleri, .udf dosya iliskisi.
    EOS
  end
end

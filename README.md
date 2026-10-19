# UYAP ve e-imza araçları — macOS Apple Silicon (M1/M2/M3/M4) Homebrew Tap

Avukatlar, bilirkişiler, arabulucular, noterler, mali müşavirler, doktorlar, mühendis ve mimarlar, gümrük müşavirleri, şirket yetkilileri ve kamu çalışanları için: UYAP, KEP, e-tebligat ve e-imza araçlarını **MacBook, MacBook Pro, MacBook Air, Mac mini ve iMac**'de (Apple Silicon / M serisi / ARM tabanlı işlemci) çalıştıran kurulum paketleri. Mac'te **"e-imza çalışmıyor"**, "UYAP/JNLP açılmıyor", "Java hatası" sorunlarına çözüm.

## Neden Mac'te e-imza çalışmıyor?

Bu paketlerin çözdüğü asıl sorun: Türkiye'deki e-imza/UYAP araçlarının çoğu Windows için yazılmıştı ya da Java Web Start (JNLP) ile dağıtılıyordu. **Java Web Start, Java 11 ile birlikte kaldırıldı**; resmî paketler de Intel (x86_64)/Rosetta'ya bağlı kaldı. Bu tap'teki paketler her aracı **gömülü arm64 Java 11** (veya native Swift) ile **MacBook, MacBook Pro, MacBook Air, Mac mini ve iMac**'de (Apple Silicon / M serisi / ARM tabanlı işlemci) çalışır hâle getirir. Her uygulamanın deposunda "neden bozuktu, nasıl çözdük" anlatımı ayrıntılı olarak vardır.

## Kurulum

```bash
brew tap adeministratorr/tap
```

> Homebrew ilk kullanımda tap güvenini sorabilir; onaylayın ya da `brew trust adeministratorr/tap` çalıştırın.

### Hazır DMG ile (cask — derleme yok, en hızlı)

| Uygulama | Ne için | Kurulum |
|---|---|---|
| E-Devlet E-İmza | e-Devlet'e e-imza ile giriş ve imzalama | `brew install --cask adeministratorr/tap/edevlet-eimza` |
| PTT KEP E-İmza | PTT KEP Webmail e-imza (KEP yazışmaları) | `brew install --cask adeministratorr/tap/pttkep-eimza` |
| PTT UETS E-İmza | UETS / e-Tebligat imzalama | `brew install --cask adeministratorr/tap/uets-eimza` |
| TNB Teknoloji İmza | kep.hs02.kep.tr girişi (noterler; Chrome eklentisi) | `brew install --cask adeministratorr/tap/tnb-eimza` |
| UHAP İmzalama | uhap.com.tr ve CMK (baro) imzalama akışı | `brew install --cask adeministratorr/tap/uhap-eimza` |
| UDF Görüntüleyici | Finder'da `.udf` önizleme (QuickLook) | `brew install --cask adeministratorr/tap/udf-quicklook` |
| UYAP Doküman Editörü | `.udf` açma/düzenleme (arm64 native) | `brew install --cask adeministratorr/tap/ude-mac-arm64` |

### Kaynaktan derleyerek (formula)

Aynı adlarla: `brew install adeministratorr/tap/<uygulama>` — örn:

```bash
brew install adeministratorr/tap/edevlet-eimza
```

Formüller kendi makinenizde derler; UDF ve TNB formülleri, Homebrew derleme sandbox'ında çalışabilmek için gereken yamaları kendisi uygular. Derleme sonrası `eimza-install-*` yardımcı komutuyla uygulamayı /Applications'a kurun.

## Homebrew yok mu? — DMG ile kurun

Her uygulamanın deposundaki **Releases** bölümünde hazır arm64 DMG'ler var:

- [E-Devlet E-İmza](https://github.com/adeministratorr/edevlet-eimza-mac-arm64/releases) · [PTT KEP](https://github.com/adeministratorr/pttkep-eimza-mac-arm64/releases) · [PTT UETS](https://github.com/adeministratorr/uets-eimza-mac-arm64/releases) · [TNB](https://github.com/adeministratorr/tnb-eimza-mac-arm64/releases) · [UHAP](https://github.com/adeministratorr/uhap-eimza-mac-arm64/releases) · [UDF](https://github.com/adeministratorr/udf-quicklook-extension/releases) · [UYAP Editör](https://github.com/adeministratorr/ude-mac-arm64-1/releases)

## Sık sorulan sorular

- **MacBook'umda e-imza çalışır mı?** Evet — paketler Apple Silicon (M1/M2/M3/M4) için native arm64'tür; Rosetta veya ayrı Java kurulumu gerekmez.
- **Intel Mac'im var, çalışır mı?** Bu paketler arm64'tür; Intel desteklemez. (UYAP Doküman Editörü paketi Intel'de de derlenebilir, bkz. ilgili depo.)
- **Mac'te "e-imza çalışmıyor", nereden başlamalıyım?** Önce doğru uygulamayı kurun (yukarıdaki tablo), sonra e-imza kartı sürücüsünü (arm64 AKİS) kurun.
- **Kartım görünmüyor / "Akıllı Kart Bulunamadı"?** arm64 AKİS sürücüsü eksik: https://akiskart.bilgem.tubitak.gov.tr/tr/destek/ → "Mac OS Arm (Apple Silicon)" paketi. Kontrol: `lipo -archs /usr/local/lib/libakisp11.dylib` çıktısı `arm64` içermeli.
- **PTT KEP mi UETS mi kurayım?** İşlem kodunuzu hangi arayüzden aldıysanız onu kurun — UETS (e-tebligat) ile PTT KEP Webmail farklı uygulamalardır, kodlar karşılıklı geçmez.
- **Noterler hangi paketi kullanır?** TNB paketi (Türkiye Noterler Birliği KEP girişi).
- **Gatekeeper "geliştirici doğrulanamadı" derse?** Cask kurulumları karantinayı otomatik kaldırır; `kur.sh` yolu ise uygulamayı kendi makinenizde derleyip imzaladığı için uyarı çıkmaz. Yine çıkarsa: sağ tık → Aç.

## Bu tap nedir?

Bu tap, [saidsurucu](https://github.com/saidsurucu) projelerinin Apple Silicon dağıtımını kolaylaştırır: hazır DMG release'leri + Homebrew cask/formül sarmalayıcıları içerir. UDF paketinde ek düzeltmeler (uygulama ikonu, karşılama penceresi) bu dağıtım sürümünde bulunur. Orijinal projeler ve teorik çalışma proje sahibine aittir; bu tap hiçbir kamu kurumuyla bağlantılı değildir (gayriresmî).

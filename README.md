# macOS için e-imza ve UYAP araçları — Kurulum merkezi

> **Kısa yanıt:** Mac'te e-Devlet'e e-imza ile girmeniz, UYAP belgesi açmanız, `.udf` önizlemesi ya da KEP/UETS işlemi yapmanız mı gerekiyor? Bu depo, bunun için gereken kurulum paketlerini tek yerde toplar. İşleminize uygun uygulamayı aşağıdaki tablodan seçin.
>
> **Önce resmî uygulamalar:** UYAP'ın resmî [Adalet E-İmza](https://bedesten.adalet.gov.tr/imza/) uygulaması ve resmî [UYAP Doküman Editörü](https://www.uyap.gov.tr/Uyap-Editor) önceliklidir. Bu depodaki paketler **gayriresmî topluluk dağıtımlarıdır** ve resmî uygulamaların yerine geçmez. UYAP'a ArkSigner/e-imza uygulamasıyla giriş 1 Haziran 2026'da sonlandırıldı; giriş artık e-Devlet Kapısı veya Adalet E-İmza üzerinden yapılır.

## Hangi uygulamayı kurmalıyım?

| İşlem | Uygulama | En kolay kurulum |
|---|---|---|
| e-Devlet Kapısı'na e-imza ile giriş | E-Devlet E-İmza | `brew install --cask adeministratorr/tap/edevlet-eimza` |
| PTT KEP Webmail'de imzalama | PTT KEP E-İmza | `brew install --cask adeministratorr/tap/pttkep-eimza` |
| UETS / e-Tebligat imzalama | PTT UETS E-İmza | `brew install --cask adeministratorr/tap/uets-eimza` |
| TNB KEP girişi (Chrome eklentisi) | TNB Teknoloji İmza | `brew install --cask adeministratorr/tap/tnb-eimza` |
| UHAP ve CMK imzalama akışı | UHAP İmzalama | `brew install --cask adeministratorr/tap/uhap-eimza` |
| UDF dosyasını yalnız görüntüleme | UDF Görüntüleyici (QuickLook) | `brew install --cask adeministratorr/tap/udf-quicklook` |
| UDF açma / düzenleme | UYAP Doküman Editörü paketi | `brew install --cask adeministratorr/tap/ude-mac-arm64` |
| UDF açma / düzenleme (resmî) | UYAP Doküman Editörü 5.4.21+ | [uyap.gov.tr/Uyap-Editor](https://www.uyap.gov.tr/Uyap-Editor) |
| UYAP'a giriş (resmî) | Adalet E-İmza | [bedesten.adalet.gov.tr/imza](https://bedesten.adalet.gov.tr/imza/) |

Homebrew yoksa her uygulamanın **Releases** sayfasından DMG indirilebilir (aşağıda bağlantılar var).

## İlk kez kuranlar için

1. **Kart sürücüsü:** Akıllı kartınız görünmüyorsa önce arm64 AKİS sürücüsünü kurun: [akiskart.bilgem.tubitak.gov.tr/destek](https://akiskart.bilgem.tubitak.gov.tr/destek/) → **"Mac OS Arm (Apple Silicon)"**. Kontrol: `lipo -archs /usr/local/lib/libakisp11.dylib` çıktısı `arm64` içermeli.
2. **Uygulama:** Tablodan işleminize uygun paketi seçin. Hazır DMG en hızlı yoldur; Homebrew isteğe bağlıdır.
3. **Başarılı kurulum nasıl anlaşılır?** Uygulama açıldığında imza/PIN penceresi gelir; tarayıcıdaki "imzalama aracı açık mı?" hatası kaybolur. UDF görüntüleyicide Finder'da dosya seçip **Boşluk** tuşuna basınca önizleme açılır.
4. **Sık hata:** "Akıllı Kart Bulunamadı" → sürücü eksik/Intel sürücü kurulu. Gatekeeper uyarısı → cask kurulumu karantinayı kaldırır; yine çıkarsa sağ tık → **Aç**.
5. **Önemli sınır:** Paketler resmî kurum uygulaması değildir; test edilmemiş kart, portal ve işlemler ilgili deponun README'sinde ayrıca yazılıdır. İmza PIN'inizi hiçbir komuta, issue'ya veya kişiye yazmayın.

> **Güvenlik notu:** Kurulum betiklerini (`kur.sh`) çalıştırmadan önce içeriğini inceleyin. E-imza/UYAP paketlerinin DMG'leri Developer ID ile imzalı ve Apple notarizasyonundan geçmiştir; sürüm notlarında `sha256` değerleri bulunur. Ad-hoc imza, Apple notarizasyonu değildir.

## Homebrew ile kurulum (isteğe bağlı)

```bash
brew tap adeministratorr/tap
```

> Homebrew ilk kullanımda tap güvenini sorabilir; onaylayın ya da `brew trust adeministratorr/tap` çalıştırın.

### Hazır DMG (cask — derleme yok, en hızlı)

Tablodaki `brew install --cask ...` komutlarını kullanın. Cask'ler hazır arm64 DMG'yi indirir; derleme gerektirmez.

### Kaynaktan derleyerek (formula)

Aynı adlarla: `brew install adeministratorr/tap/<uygulama>` — örn. `brew install adeministratorr/tap/edevlet-eimza`. Formüller kendi makinenizde derler; UDF ve TNB formülleri Homebrew derleme sandbox'ı için gereken yamaları uygular. Derleme sonrası `eimza-install-*` yardımcı komutuyla uygulamayı `/Applications`'a kurun.

### Homebrew yok mu? — DMG ile kurun

[E-Devlet E-İmza](https://github.com/adeministratorr/edevlet-eimza-mac-arm64/releases) · [PTT KEP](https://github.com/adeministratorr/pttkep-eimza-mac-arm64/releases) · [PTT UETS](https://github.com/adeministratorr/uets-eimza-mac-arm64/releases) · [TNB](https://github.com/adeministratorr/tnb-eimza-mac-arm64/releases) · [UHAP](https://github.com/adeministratorr/uhap-eimza-mac-arm64/releases) · [UDF](https://github.com/adeministratorr/udf-quicklook-extension/releases) · [UYAP Editör](https://github.com/adeministratorr/ude-mac-arm64-1/releases)

## Diğer uygulamalar

Bu bölümdeki paket e-imza/UYAP ile ilgili değildir:

| Uygulama | Ne için | Kurulum |
|---|---|---|
| iDownload Manager | Genel amaçlı indirme yöneticisi | `brew install --cask adeministratorr/tap/i-download-manager` |

## Sık sorulan sorular

- **MacBook'umda e-imza çalışır mı?** Paketler Apple Silicon (M serisi) için native arm64'tür; Rosetta veya ayrı Java kurulumu gerekmez.
- **Intel Mac'im var, çalışır mı?** Bu paketler arm64'tür; Intel desteklemez. UYAP Doküman Editörü'nün resmî sürümünde hem Intel hem Apple Silicon paketi bulunur.
- **PTT KEP mi UETS mi kurayım?** İşlem kodunuzu hangi arayüzden aldıysanız onu kurun — UETS (e-tebligat) ile PTT KEP Webmail farklı uygulamalardır, kodlar karşılıklı geçmez.
- **Noterler hangi paketi kullanır?** TNB KEP girişi için TNB paketi; UYAP işlemleri için önce resmî Adalet E-İmza ve resmî editör.
- **Kartım görünmüyor / "Akıllı Kart Bulunamadı"?** arm64 AKİS sürücüsü eksik olabilir; yukarıdaki sürücü adımına bakın.
- **Gatekeeper "geliştirici doğrulanamadı" derse?** Cask kurulumları karantinayı kaldırır; `kur.sh` yolu uygulamayı kendi makinenizde derler. Yine çıkarsa: sağ tık → **Aç**.

## Bu tap nedir?

Bu tap, [adeministratorr](https://github.com/adeministratorr) tarafından sürdürülen Apple Silicon dağıtımlarını toplar: hazır DMG release'leri + Homebrew cask/formül sarmalayıcıları. Paketlerin çoğu [saidsurucu](https://github.com/saidsurucu) projelerinin fork'udur; özgün projeler ve teorik çalışma proje sahibine aittir. Bu tap hiçbir kamu kurumuyla bağlantılı değildir (gayriresmî).

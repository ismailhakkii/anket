# Anket & Karar Uygulaması

Eğlenceli ve modern bir Flutter uygulaması: anket oluşturma/katılma ve özelleştirilebilir karar çarkı özellikleri.

## Özellikler

- Anket listesi ve katılma
- Kendi sorularınızı ve seçeneklerinizi oluşturarak anket kaydetme
- Karar çarkını özelleştirilebilir renk ve metin seçenekleriyle kaydetme
- Çark sonucu konfeti animasyonu ile kutlama
- Offline Poppins font ile hızlı başlangıç
- Light/Dark tema desteği (sistem ayarına göre)
- SharedPreferences ile yerel veritabanı
- BLoC state yönetimi ve get_it DI
- Clean Architecture katmanları (data, domain, presentation)
- Gradient arkaplan, Lottie animasyonları, modern UI tasarımları

## Kurulum ve Çalıştırma

1. Depoyu klonlayın:
   ```bash
   git clone <repo_url>
   cd anket
   ```
2. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
3. `assets/fonts/` dizinine Poppins font dosyalarını ekleyin:
   - Poppins-Regular.ttf
   - Poppins-SemiBold.ttf
   - Poppins-Bold.ttf
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

### Uygulama İkonu ve Splash Ekranı

- `flutter_launcher_icons` ve `flutter_native_splash` paketleri yapılandırıldı.
- Yeni ikon ve splash oluşturmak için:
  ```bash
  flutter pub run flutter_launcher_icons:main
  flutter pub run flutter_native_splash:create
  ```

## Proje Yapısı

```
lib/
  main.dart
  injection_container.dart
  features/
    survey/    # Anket katılım ve yönetimi
    decision/  # Karar çarkı oluşturma ve kullanma
```

## Kullanım

- Ana sayfada anketleri görüntüleyin veya yeni anket oluşturun.
- Karar çarkı sayfasında mevcut çarkları kullanın veya yeni bir çark oluşturun.
- Kayıt edilen anketler ve çarklar SharedPreferences ile yerelde saklanır.

## Sorun Giderme

- Uygulama donuyor veya font yükleme hatası alıyorsanız:
  - `GoogleFonts.config.allowRuntimeFetching = false` olarak ayarladığınızdan emin olun.
  - `assets/fonts/` içine gerekli font dosyalarının doğru adla yüklendiğini kontrol edin.
  - Emülatörün internet bağlantısı sorunlarına karşı fiziksel cihazda test edin.

## Lisans

BSD 3-Clause License

# Firebase Yapılandırmasını Kontrol Etme Rehberi

## 🧪 Test Ekranı ile Kontrol

### 1. Uygulamayı Çalıştırın
```bash
flutter run
```

### 2. Test Ekranına Gidin
- Settings (Ayarlar) → Firebase Test

### 3. Durum Kontrolleri

#### ✅ Firebase Core
- **Beklenen**: "✅ Bağlı" mesajı
- **App Name**: Firebase app adı görünmeli
- **Project ID**: `simple-water-reminder-889b9` görünmeli

#### ✅ Firebase Analytics
- **Beklenen**: "✅ Çalışıyor" mesajı
- **Test Event**: "Test Event Gönder" butonuna tıklayın
- **Kontrol**: Firebase Console → Analytics → Events'te `test_event` görünmeli

#### ✅ Firebase Crashlytics
- **Beklenen**: "✅ Aktif" mesajı
- **Test Error**: "Test Error Gönder" butonuna tıklayın
- **Kontrol**: Firebase Console → Crashlytics'te test error görünmeli

## 📊 Firebase Console'da Kontrol

### 1. Firebase Console'a Gidin
https://console.firebase.google.com/project/simple-water-reminder-889b9

### 2. Analytics Kontrolü
- **Yol**: Analytics → Events
- **Beklenen Event'ler**:
  - `test_event` (test ekranından)
  - `water_added` (su ekleme)
  - `screen_view` (ekran görüntüleme)

### 3. Crashlytics Kontrolü
- **Yol**: Crashlytics → Issues
- **Beklenen**: Test error'ları görünmeli

## 🔍 Manuel Kontrol Yöntemleri

### 1. Log Kontrolü
Uygulamayı çalıştırırken terminal'de şu log'ları kontrol edin:
```
✅ Firebase initialized successfully
✅ Analytics ready
✅ Crashlytics enabled
```

### 2. Xcode Console (iOS)
Xcode'da uygulamayı çalıştırırken Console'da:
```
[Firebase/Core] Firebase initialized
[Firebase/Analytics] Analytics initialized
[Firebase/Crashlytics] Crashlytics initialized
```

### 3. Firebase Console → Project Settings
- **iOS App**: `com.formneo.waterneo` görünmeli
- **GoogleService-Info.plist**: Yüklü olmalı
- **Status**: ✅ Aktif

## ⚠️ Sorun Giderme

### Firebase Başlatılamıyor
1. `GoogleService-Info.plist` dosyasının `ios/Runner/` klasöründe olduğunu kontrol edin
2. Xcode'da dosyanın projeye eklendiğini kontrol edin
3. `pod install` çalıştırın:
   ```bash
   cd ios && pod install && cd ..
   ```

### Analytics Event'leri Görünmüyor
1. Firebase Console'da Analytics'in aktif olduğunu kontrol edin
2. Event'lerin görünmesi birkaç dakika sürebilir
3. Debug modda test edin (production'da delay olabilir)

### Crashlytics Çalışmıyor
1. Crashlytics'in Firebase Console'da aktif olduğunu kontrol edin
2. Test error'larının görünmesi birkaç dakika sürebilir
3. Uygulamayı kapatıp tekrar açın (crash report gönderimi için)

## ✅ Başarı Kriterleri

- [ ] Firebase Core bağlantısı başarılı
- [ ] Analytics event'leri gönderiliyor
- [ ] Crashlytics error'ları kaydediliyor
- [ ] Firebase Console'da veriler görünüyor
- [ ] Test ekranında tüm durumlar ✅ gösteriyor

## 📝 Notlar

- Test event'leri Firebase Console'da görünmesi için birkaç dakika bekleyin
- Production'da Analytics event'leri 24 saat içinde görünebilir
- Crashlytics error'ları genellikle birkaç dakika içinde görünür
- Debug modda test ederken daha hızlı sonuç alırsınız


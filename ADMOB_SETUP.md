# AdMob Kurulum Rehberi

## ✅ Tamamlananlar

### App ID
- **Android & iOS**: `ca-app-pub-2445586481446436~6818108688` ✅
- AndroidManifest.xml'e eklendi ✅
- Info.plist'e eklendi ✅

## 📋 Gerekli Ad Unit ID'leri

### 1. Banner Ad Unit ID
- **Android Banner**: `ca-app-pub-2445586481446436/XXXXXXXXXX`
- **iOS Banner**: `ca-app-pub-2445586481446436/XXXXXXXXXX`

### 2. Interstitial Ad Unit ID
- **Android Interstitial**: `ca-app-pub-2445586481446436/XXXXXXXXXX`
- **iOS Interstitial**: `ca-app-pub-2445586481446436/XXXXXXXXXX`

## 🔍 Ad Unit ID'lerini Nasıl Bulursunuz?

1. [AdMob Console](https://apps.admob.com/) → Apps → Waterly
2. Ad units sekmesine gidin
3. "Add ad unit" butonuna tıklayın
4. Ad formatını seçin:
   - **Banner** → Ad unit oluştur → ID'yi kopyalayın
   - **Interstitial** → Ad unit oluştur → ID'yi kopyalayın
5. Her platform için ayrı ad unit oluşturun (Android ve iOS)

## 📝 Şu Anki Durum

- ✅ App ID eklendi
- ⚠️ Ad Unit ID'leri test modunda (gerçek ID'ler eklenecek)

## 🚀 Gerçek ID'leri Eklemek İçin

Gerçek Ad Unit ID'lerinizi aldıktan sonra:
1. `lib/services/ads_service.dart` dosyasındaki `_getBannerAdUnitId()` ve `_getInterstitialAdUnitId()` fonksiyonlarını güncelleyin
2. Platform kontrolü ekleyin (Android/iOS)

Örnek format:
```dart
String _getBannerAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-2445586481446436/YOUR_ANDROID_BANNER_ID';
  } else {
    return 'ca-app-pub-2445586481446436/YOUR_IOS_BANNER_ID';
  }
}
```


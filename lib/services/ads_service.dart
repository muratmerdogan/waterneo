import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/premium_status.dart';

/// Ads Service - AdMob entegrasyonu
class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  BannerAd? _bannerAd;

  bool _isInitialized = false;
  PremiumStatus _premiumStatus = PremiumStatus.free();

  /// Ads servisini başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    // AdMob App ID ile initialize et
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  /// Premium durumunu güncelle
  void updatePremiumStatus(PremiumStatus status) {
    _premiumStatus = status;
    if (status.isPremium) {
      // Premium kullanıcılar için reklamları kaldır
      _bannerAd?.dispose();
      _bannerAd = null;
    }
  }

  /// Banner ad oluştur
  BannerAd? createBannerAd() {
    if (_premiumStatus.isPremium) return null;

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
    return _bannerAd;
  }

  /// Interstitial ad göster (su ekleme sonrası)
  /// NOT: Interstitial ads kullanılmıyor, sadece banner ads aktif
  void showInterstitialAdOnWaterLog() {
    // Interstitial ads devre dışı - sadece banner ads kullanılıyor
    return;
  }

  /// Banner Ad Unit ID - Gerçek ID
  String _getBannerAdUnitId() {
    // Banner Ad Unit ID (Android ve iOS için aynı)
    return 'ca-app-pub-2445586481446436/4902391780';
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}


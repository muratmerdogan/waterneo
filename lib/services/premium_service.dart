import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import '../models/premium_status.dart';
import 'storage_service.dart';

/// Premium Subscription Service - RevenueCat entegrasyonu
class PremiumService {
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  PremiumService._internal();

  final StorageService _storageService = StorageService();
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY'; // TODO: Replace with actual key
  bool _isInitialized = false;

  /// Premium servisini başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Purchases.configure(
        PurchasesConfiguration(_apiKey),
      );
      _isInitialized = true;
    } catch (e) {
      // RevenueCat başlatılamadı, offline modda devam et
      print('RevenueCat initialization failed: $e');
    }
  }

  /// Premium durumunu kontrol et
  Future<PremiumStatus> checkPremiumStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isPremium = customerInfo.entitlements.active.isNotEmpty;
      
      if (isPremium) {
        final entitlement = customerInfo.entitlements.active.values.first;
        final isLifetime = entitlement.productIdentifier.contains('lifetime');
        return PremiumStatus.premium(
          expiryDate: entitlement.expirationDate != null
              ? DateTime.parse(entitlement.expirationDate!)
              : null,
          isLifetime: isLifetime,
        );
      }
    } catch (e) {
      // Hata durumunda local storage'dan kontrol et
      return await _loadLocalPremiumStatus();
    }

    return PremiumStatus.free();
  }

  /// Abonelik paketlerini getir
  Future<List<Package>> getAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
    } catch (e) {
      print('Error getting packages: $e');
    }
    return [];
  }

  /// Abonelik satın al
  Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      final isPremium = customerInfo.entitlements.active.isNotEmpty;
      
      if (isPremium) {
        final status = await checkPremiumStatus();
        await _saveLocalPremiumStatus(status);
        return true;
      }
    } catch (e) {
      if (e is PlatformException) {
        final code = e.code;
        if (code == PurchasesErrorCode.purchaseCancelledError.toString()) {
          // Kullanıcı iptal etti
          return false;
        }
      }
      print('Purchase error: $e');
    }
    return false;
  }

  /// Satın alımları geri yükle
  Future<PremiumStatus> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      final isPremium = customerInfo.entitlements.active.isNotEmpty;
      
      if (isPremium) {
        final status = await checkPremiumStatus();
        await _saveLocalPremiumStatus(status);
        return status;
      }
    } catch (e) {
      print('Restore error: $e');
    }
    return PremiumStatus.free();
  }

  /// Local storage'dan premium durumunu yükle
  Future<PremiumStatus> _loadLocalPremiumStatus() async {
    try {
      final json = await _storageService.loadJson('premium_status');
      if (json != null) {
        return PremiumStatus.fromJson(json as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error loading premium status: $e');
    }
    return PremiumStatus.free();
  }

  /// Premium durumunu local storage'a kaydet
  Future<void> _saveLocalPremiumStatus(PremiumStatus status) async {
    await _storageService.saveJson('premium_status', status.toJson());
  }
}


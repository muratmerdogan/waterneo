import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'config/app_theme.dart';
import 'utils/theme_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/ads_service.dart';
import 'services/premium_service.dart';
import 'ui/screens/new_onboarding_screen.dart';
import 'ui/screens/modern_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase'i başlat (zorunlu)
  await Firebase.initializeApp();
  
  // Crashlytics'i yapılandır
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  // Platform hatalarını yakala
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  // iOS için status bar ayarları
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // Bildirim servisini başlat
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  // Ads servisini başlat
  final adsService = AdsService();
  await adsService.initialize();
  
  // Premium servisini başlat
  final premiumService = PremiumService();
  await premiumService.initialize();
  
  // Premium durumunu kontrol et ve ads servisine bildir
  final premiumStatus = await premiumService.checkPremiumStatus();
  adsService.updatePremiumStatus(premiumStatus);
  
  runApp(
    const ProviderScope(
      child: WaterlyApp(),
    ),
  );
}

class WaterlyApp extends ConsumerWidget {
  const WaterlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Waterly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const _InitialScreen(),
    );
  }
}

/// İlk açılışta onboarding kontrolü yapan widget
class _InitialScreen extends ConsumerStatefulWidget {
  const _InitialScreen();

  @override
  ConsumerState<_InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<_InitialScreen> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final storageService = StorageService();
    final settings = await storageService.loadUserSettings();
    
    setState(() {
      _showOnboarding = !settings.onboardingCompleted;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _showOnboarding
        ? const NewOnboardingScreen()
        : const ModernDashboardScreen();
  }
}

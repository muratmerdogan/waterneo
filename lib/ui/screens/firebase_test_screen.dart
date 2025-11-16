import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../config/design_system.dart';
import '../../services/analytics_service.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_button.dart';

/// Firebase Test Screen - Firebase yapılandırmasını test eder
class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _firebaseStatus = 'Kontrol ediliyor...';
  String _analyticsStatus = 'Kontrol ediliyor...';
  String _crashlyticsStatus = 'Kontrol ediliyor...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirebaseStatus();
  }

  Future<void> _checkFirebaseStatus() async {
    try {
      // Firebase Core kontrolü
      final app = Firebase.app();
      _firebaseStatus = '✅ Bağlı\n'
          'App: ${app.name}\n'
          'Options: ${app.options.projectId}';
    } catch (e) {
      _firebaseStatus = '❌ Hata: $e';
    }

    try {
      // Analytics kontrolü
      final analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(name: 'test_event', parameters: {'test': 'true'});
      _analyticsStatus = '✅ Çalışıyor\nTest event gönderildi';
    } catch (e) {
      _analyticsStatus = '❌ Hata: $e';
    }

    try {
      // Crashlytics kontrolü
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      _crashlyticsStatus = '✅ Aktif\nCrash tracking açık';
    } catch (e) {
      _crashlyticsStatus = '❌ Hata: $e';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testAnalytics() async {
    try {
      final analytics = AnalyticsService();
      await analytics.logWaterAdded(250);
      await analytics.logScreenView('test_screen');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Analytics test event gönderildi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testCrashlytics() async {
    try {
      // Test crash (non-fatal)
      await FirebaseCrashlytics.instance.recordError(
        Exception('Test error - Firebase çalışıyor'),
        StackTrace.current,
        fatal: false,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Test error Crashlytics\'e gönderildi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSystem.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Firebase Yapılandırma Durumu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              // Firebase Core Status
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud, color: Colors.orange),
                        const SizedBox(width: DesignSystem.spacingS),
                        Text(
                          'Firebase Core',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        _firebaseStatus,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              // Analytics Status
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: Colors.blue),
                        const SizedBox(width: DesignSystem.spacingS),
                        Text(
                          'Firebase Analytics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        _analyticsStatus,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: DesignSystem.spacingM),
                    ModernButton(
                      text: 'Test Event Gönder',
                      icon: Icons.send,
                      isPrimary: true,
                      onPressed: _testAnalytics,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              // Crashlytics Status
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bug_report, color: Colors.red),
                        const SizedBox(width: DesignSystem.spacingS),
                        Text(
                          'Firebase Crashlytics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        _crashlyticsStatus,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: DesignSystem.spacingM),
                    ModernButton(
                      text: 'Test Error Gönder',
                      icon: Icons.error_outline,
                      isOutlined: true,
                      onPressed: _testCrashlytics,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              // Bilgilendirme
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(height: DesignSystem.spacingS),
                    Text(
                      'Kontrol Adımları',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: DesignSystem.spacingS),
                    Text(
                      '1. Test Event Gönder butonuna tıklayın\n'
                      '2. Firebase Console → Analytics → Events\'e gidin\n'
                      '3. "test_event" veya "water_added" event\'ini kontrol edin\n'
                      '4. Test Error Gönder butonuna tıklayın\n'
                      '5. Firebase Console → Crashlytics\'e gidin\n'
                      '6. Test error\'ı kontrol edin',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../config/design_system.dart';
import '../../services/premium_service.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_button.dart';

/// Premium/Paywall Screen
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  String? _selectedPlan; // 'monthly', 'yearly', 'lifetime'
  Package? _selectedPackage;
  bool _isLoading = false;
  final PremiumService _premiumService = PremiumService();
  List<Package> _packages = [];

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    await _premiumService.initialize();
    final packages = await _premiumService.getAvailablePackages();
    setState(() {
      _packages = packages;
      if (_packages.isNotEmpty && _selectedPlan == null) {
        // Varsayılan olarak yearly'yi seç
        _selectedPackage = _packages.firstWhere(
          (p) => p.identifier == 'yearly',
          orElse: () => _packages.first,
        );
        _selectedPlan = _selectedPackage?.identifier;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Premium'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: DesignSystem.spacingXL),
              // Premium Icon
              Container(
                padding: const EdgeInsets.all(DesignSystem.spacingXL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Text(
                'Unlock Premium',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'Get the most out of Waterly',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: DesignSystem.spacingXXL),
              // Features
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingM,
                ),
                child: Column(
                  children: [
                    _buildFeature(
                      icon: Icons.block,
                      title: 'Remove Ads',
                      description: 'Enjoy an ad-free experience',
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    _buildFeature(
                      icon: Icons.local_cafe,
                      title: 'Caffeine Tracking',
                      description: 'Track your daily caffeine intake',
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    _buildFeature(
                      icon: Icons.auto_awesome,
                      title: 'Smart Goal Recommendations',
                      description: 'AI-powered hydration goals',
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    _buildFeature(
                      icon: Icons.favorite,
                      title: 'Health Integrations',
                      description: 'Sync with Apple Health & Google Fit',
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    _buildFeature(
                      icon: Icons.palette,
                      title: 'Exclusive Themes',
                      description: 'Beautiful premium themes',
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    _buildFeature(
                      icon: Icons.notifications_active,
                      title: 'Premium Notifications',
                      description: 'Customizable notification themes',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXXL),
              // Pricing Plans
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Plan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    if (_packages.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(DesignSystem.spacingL),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      ..._packages.map((package) {
                        final isPopular = package.identifier == 'yearly';
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: DesignSystem.spacingS,
                          ),
                          child: _buildPlanOptionFromPackage(
                            package: package,
                            isPopular: isPopular,
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              // Subscribe Button
              Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingM),
                child: ModernButton(
                  text: _selectedPackage == null
                      ? 'Select a Plan'
                      : 'Subscribe Now',
                  isPrimary: true,
                  isLoading: _isLoading,
                  onPressed: _selectedPackage == null || _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final success = await _premiumService.purchasePackage(
                            _selectedPackage!,
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          if (mounted) {
                            if (success) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: DesignSystem.spacingS),
                                      Text('Welcome to Premium! 🎉'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Purchase cancelled or failed'),
                                ),
                              );
                            }
                          }
                        },
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              // Restore Purchases
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final status = await _premiumService.restorePurchases();

                        setState(() {
                          _isLoading = false;
                        });

                        if (mounted) {
                          if (status.isPremium) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Purchases restored successfully!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No purchases found to restore'),
                              ),
                            );
                          }
                        }
                      },
                child: const Text('Restore Purchases'),
              ),
              const SizedBox(height: DesignSystem.spacingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ModernCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionFromPackage({
    required Package package,
    required bool isPopular,
  }) {
    final isSelected = _selectedPackage?.identifier == package.identifier;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = package;
          _selectedPlan = package.identifier;
        });
      },
      child: AnimatedContainer(
        duration: DesignSystem.animationMedium,
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: 2,
                ),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        package.storeProduct.priceString,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: DesignSystem.spacingS),
                      if (isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                              DesignSystem.radiusSmall,
                            ),
                          ),
                          child: Text(
                            'POPULAR',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    package.storeProduct.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

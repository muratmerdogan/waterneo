import 'package:flutter/material.dart';
import '../../config/app_strings.dart';

/// Onboarding sayfası widget'ı
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageEmoji;
  final Widget? content;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageEmoji,
    this.content,
    this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji/Icon
              Text(
                imageEmoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 32),
              // Başlık
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Açıklama
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // İçerik (opsiyonel)
              if (content != null) ...[
                Expanded(child: content!),
                const SizedBox(height: 32),
              ],
              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onSkip != null)
                    TextButton(
                      onPressed: onSkip,
                      child: Text(AppStrings.skip),
                    )
                  else
                    const SizedBox(),
                  if (onNext != null)
                    ElevatedButton(
                      onPressed: onNext,
                      child: Text(AppStrings.next),
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


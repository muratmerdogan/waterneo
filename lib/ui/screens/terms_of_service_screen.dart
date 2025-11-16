import 'package:flutter/material.dart';
import '../../config/design_system.dart';

/// Terms of Service Screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSystem.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: DesignSystem.spacingS),
              Text(
                'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              _buildSection(
                context,
                '1. Acceptance of Terms',
                'By downloading, installing, or using Waterly ("the App"), developed by Formneo, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
              ),
              _buildSection(
                context,
                '2. Description of Service',
                'Waterly is a mobile application designed to help users track their daily water intake, set hydration goals, and receive reminders. The App provides features including but not limited to:\n\n'
                '• Daily water intake tracking\n'
                '• Personalized hydration goals\n'
                '• Reminder notifications\n'
                '• Statistics and analytics\n'
                '• Premium features (with subscription)',
              ),
              _buildSection(
                context,
                '3. Use of the Service',
                'You agree to use the App only for lawful purposes and in accordance with these Terms. You agree not to:\n\n'
                '• Use the App in any way that violates applicable laws\n'
                '• Attempt to gain unauthorized access to the App\n'
                '• Interfere with or disrupt the App\'s functionality\n'
                '• Use automated systems to access the App\n'
                '• Reverse engineer or attempt to extract source code',
              ),
              _buildSection(
                context,
                '4. Health Information Disclaimer',
                'The App is designed for informational purposes only and is not intended to diagnose, treat, cure, or prevent any disease or health condition. The water intake recommendations provided are general guidelines and may not be appropriate for everyone.\n\n'
                'Always consult with a healthcare professional before making significant changes to your hydration habits, especially if you have underlying health conditions.',
              ),
              _buildSection(
                context,
                '5. Premium Subscriptions',
                'Waterly offers premium features through subscription plans:\n\n'
                '• Subscriptions are billed monthly or annually\n'
                '• Subscriptions automatically renew unless cancelled\n'
                '• You can cancel your subscription at any time\n'
                '• Refunds are subject to App Store and Google Play policies\n'
                '• Premium features are available only during active subscription period',
              ),
              _buildSection(
                context,
                '6. Intellectual Property',
                'The App and its original content, features, and functionality are owned by Formneo and are protected by international copyright, trademark, and other intellectual property laws.',
              ),
              _buildSection(
                context,
                '7. User Content',
                'You retain ownership of any data you input into the App. By using the App, you grant us a license to use, store, and process your data solely for the purpose of providing the service.',
              ),
              _buildSection(
                context,
                '8. Limitation of Liability',
                'To the maximum extent permitted by law, Formneo shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from your use of the App.',
              ),
              _buildSection(
                context,
                '9. Indemnification',
                'You agree to defend, indemnify, and hold harmless Formneo and its officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses arising out of or in any way connected with your use of the App.',
              ),
              _buildSection(
                context,
                '10. Termination',
                'We may terminate or suspend your access to the App immediately, without prior notice, for any reason, including breach of these Terms. Upon termination, your right to use the App will cease immediately.',
              ),
              _buildSection(
                context,
                '11. Changes to Terms',
                'We reserve the right to modify these Terms at any time. We will notify users of any material changes by updating the "Last updated" date. Your continued use of the App after such modifications constitutes acceptance of the updated Terms.',
              ),
              _buildSection(
                context,
                '12. Governing Law',
                'These Terms shall be governed by and construed in accordance with the laws of [Your Country/Jurisdiction], without regard to its conflict of law provisions.',
              ),
              _buildSection(
                context,
                '13. Contact Information',
                'If you have any questions about these Terms of Service, please contact us at:\n\n'
                'Company: Formneo\n'
                'Email: info@formneo.com\n'
                'Website: www.formneo.com',
              ),
              const SizedBox(height: DesignSystem.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}


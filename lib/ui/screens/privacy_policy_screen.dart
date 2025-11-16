import 'package:flutter/material.dart';
import '../../config/design_system.dart';

/// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSystem.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
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
                '1. Introduction',
                'Formneo ("we", "our", or "us"), the developer of Waterly, is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
              ),
              _buildSection(
                context,
                '2. Information We Collect',
                'We collect information that you provide directly to us, including:\n\n'
                '• Personal Information: Weight, gender, activity level, and daily water intake goals\n'
                '• Usage Data: Water intake records, reminder settings, and app usage patterns\n'
                '• Device Information: Device type, operating system, and unique device identifiers',
              ),
              _buildSection(
                context,
                '3. How We Use Your Information',
                'We use the information we collect to:\n\n'
                '• Provide and maintain our service\n'
                '• Send you personalized reminders and notifications\n'
                '• Calculate and track your daily water intake goals\n'
                '• Improve our app and develop new features\n'
                '• Analyze usage patterns to enhance user experience',
              ),
              _buildSection(
                context,
                '4. Data Storage',
                'Your data is stored locally on your device using secure storage methods. We do not transmit your personal health data to external servers unless you explicitly enable cloud sync features.',
              ),
              _buildSection(
                context,
                '5. Third-Party Services',
                'We may use third-party services that collect information used to identify you:\n\n'
                '• Google Mobile Ads: For displaying advertisements (if you are not a premium user)\n'
                '• RevenueCat: For managing premium subscriptions\n'
                '• Analytics Services: To understand app usage and improve our service\n\n'
                'These services have their own privacy policies governing data collection and use.',
              ),
              _buildSection(
                context,
                '6. Health Data',
                'If you choose to integrate with Apple Health or Google Fit, we will access your health data only with your explicit permission. This data is used solely to sync your water intake records and is not shared with third parties.',
              ),
              _buildSection(
                context,
                '7. Children\'s Privacy',
                'Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
              ),
              _buildSection(
                context,
                '8. Your Rights',
                'You have the right to:\n\n'
                '• Access your personal data\n'
                '• Correct inaccurate data\n'
                '• Delete your data\n'
                '• Export your data\n'
                '• Opt-out of data collection\n\n'
                'You can exercise these rights through the app settings or by contacting us.',
              ),
              _buildSection(
                context,
                '9. Data Security',
                'We implement appropriate technical and organizational measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure.',
              ),
              _buildSection(
                context,
                '10. Changes to This Privacy Policy',
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
              ),
              _buildSection(
                context,
                '11. Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at:\n\n'
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


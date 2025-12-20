import 'package:flutter/material.dart';
import 'package:outing/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('1. Information We Collect', 
            'We collect information you provide directly to us, including your name, email address, phone number, and location data when you use our services.'),
          _buildSection('2. How We Use Your Information',
            'We use the information we collect to provide, maintain, and improve our services, send you technical notices and support messages, and respond to your comments and questions.'),
          _buildSection('3. Information Sharing',
            'We do not share your personal information with third parties except as described in this privacy policy or with your consent.'),
          _buildSection('4. Data Security',
            'We take reasonable measures to help protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction.'),
          _buildSection('5. Your Rights',
            'You have the right to access, update, or delete your personal information at any time through your account settings.'),
          _buildSection('6. Changes to Privacy Policy',
            'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.'),
          _buildSection('7. Contact Us',
            'If you have any questions about this privacy policy, please contact us at privacy@outing.com'),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

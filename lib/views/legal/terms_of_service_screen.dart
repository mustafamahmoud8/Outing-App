import 'package:flutter/material.dart';
import 'package:outing/theme/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('1. Acceptance of Terms',
            'By accessing and using Outing, you accept and agree to be bound by the terms and provision of this agreement.'),
          _buildSection('2. Use License',
            'Permission is granted to temporarily use Outing for personal, non-commercial transitory viewing only.'),
          _buildSection('3. User Responsibilities',
            'You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device.'),
          _buildSection('4. Prohibited Uses',
            'You may not use Outing for any illegal purpose or to violate any laws in your jurisdiction.'),
          _buildSection('5. Disclaimer',
            'The materials on Outing are provided on an \'as is\' basis. Outing makes no warranties, expressed or implied.'),
          _buildSection('6. Limitations',
            'In no event shall Outing or its suppliers be liable for any damages arising out of the use or inability to use Outing.'),
          _buildSection('7. Modifications',
            'Outing may revise these terms of service at any time without notice. By using this app you are agreeing to be bound by the current version of these terms.'),
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

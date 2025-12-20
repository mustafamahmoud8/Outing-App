import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/outing_type_provider.dart';
import 'package:outing/theme/app_colors.dart';

class OutingTypeSelector extends StatelessWidget {
  const OutingTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OutingTypeProvider>(
      builder: (context, outingType, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who\'s joining?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTypeCard(
                    context,
                    OutingType.solo,
                    '👤',
                    'Solo',
                    outingType.selectedType == OutingType.solo,
                    () => outingType.setOutingType(OutingType.solo),
                  ),
                  const SizedBox(width: 12),
                  _buildTypeCard(
                    context,
                    OutingType.couple,
                    '💑',
                    'Couple',
                    outingType.selectedType == OutingType.couple,
                    () => outingType.setOutingType(OutingType.couple),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTypeCard(
                    context,
                    OutingType.friends,
                    '👥',
                    'Friends',
                    outingType.selectedType == OutingType.friends,
                    () => outingType.setOutingType(OutingType.friends),
                  ),
                  const SizedBox(width: 12),
                  _buildTypeCard(
                    context,
                    OutingType.family,
                    '👨‍👩‍👧‍👦',
                    'Family',
                    outingType.selectedType == OutingType.family,
                    () => outingType.setOutingType(OutingType.family),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    OutingType type,
    String icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

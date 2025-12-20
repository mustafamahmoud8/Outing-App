import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/budget_provider.dart';
import 'package:outing/providers/plan_provider.dart';
import 'package:outing/models/plan_item.dart';
import 'package:outing/providers/outing_type_provider.dart';
import 'package:outing/providers/group_provider.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/theme/adaptive_colors.dart';
import 'package:outing/widgets/custom_button.dart';
import 'package:outing/widgets/outing_type_selector.dart';
import 'package:outing/views/places/places_list_screen.dart';
import 'package:outing/services/smart_plan_generator.dart';
import 'package:outing/views/budget/smart_plan_screen.dart';

class UnifiedBudgetScreen extends StatefulWidget {
  const UnifiedBudgetScreen({super.key});

  @override
  State<UnifiedBudgetScreen> createState() => _UnifiedBudgetScreenState();
}

class _UnifiedBudgetScreenState extends State<UnifiedBudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Plan'),
        actions: [
          Consumer<BudgetProvider>(
            builder: (context, budget, child) {
              if (budget.totalBudget > 0) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset Budget',
                  onPressed: () => _showResetDialog(context),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budget, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Outing Type Selector
                const OutingTypeSelector(),
                const SizedBox(height: 24),

                // Who is Joining Section
                _buildWhoIsJoiningSection(context, budget),
                const SizedBox(height: 24),

                // Budget Setup or Display
                if (budget.totalBudget == 0)
                  _buildBudgetSetup(context, budget)
                else
                  _buildBudgetDisplay(context, budget),

                const SizedBox(height: 24),

                // My Plan Section
                if (budget.totalBudget > 0) ...[
                  _buildMyPlanSection(context, budget),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWhoIsJoiningSection(BuildContext context, BudgetProvider budget) {
    return Consumer2<OutingTypeProvider, GroupProvider>(
      builder: (context, outingType, groupProvider, child) {
        final participantCount = _getParticipantCount(outingType, groupProvider);
        final participantNames = _getParticipantNames(outingType, groupProvider);

        return Container(
          padding: const EdgeInsets.all(20),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Who is Joining?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Based on your outing type',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      outingType.typeIcon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outingType.typeLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AdaptiveColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$participantCount ${participantCount == 1 ? "person" : "people"}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (participantNames.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: participantNames.map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  int _getParticipantCount(OutingTypeProvider outingType, GroupProvider groupProvider) {
    switch (outingType.selectedType) {
      case OutingType.solo:
        return 1;
      case OutingType.couple:
        return 2;
      case OutingType.friends:
        return groupProvider.currentGroup?.memberNames.length ?? 3;
      case OutingType.family:
        return groupProvider.currentGroup?.memberNames.length ?? 4;
    }
  }

  List<String> _getParticipantNames(OutingTypeProvider outingType, GroupProvider groupProvider) {
    if (outingType.selectedType == OutingType.friends || 
        outingType.selectedType == OutingType.family) {
      return groupProvider.currentGroup?.memberNames ?? [];
    }
    return [];
  }

  Widget _buildBudgetSetup(BuildContext context, BudgetProvider budget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Your Budget',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Plan your perfect outing within budget',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Total Budget (EGP)',
            prefixIcon: Icon(Icons.attach_money),
            hintText: 'e.g., 500',
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _minController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Min Price Per Place (EGP)',
            prefixIcon: Icon(Icons.trending_down),
            hintText: 'e.g., 50',
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _maxController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Max Price Per Place (EGP)',
            prefixIcon: Icon(Icons.trending_up),
            hintText: 'e.g., 200',
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: AnimatedButton(
            text: 'Set Budget & Explore',
            icon: Icons.explore,
            onPressed: () => _setBudget(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetDisplay(BuildContext context, BudgetProvider budget) {
    final remaining = budget.remainingBudget;
    final percentage = budget.totalBudget > 0
        ? (budget.usedBudget / budget.totalBudget * 100).clamp(0, 100)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Budget',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${budget.totalBudget.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 80 ? Colors.red : Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spent',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${budget.usedBudget.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Remaining',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${remaining.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlacesListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.explore),
              label: const Text('Explore Places'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPlanSection(BuildContext context, BudgetProvider budget) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, child) {
        final hasPlaces = budget.selectedPlaces.isNotEmpty;
        final hasMenuItems = planProvider.itemCount > 0;
        final hasAnyItems = hasPlaces || hasMenuItems;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasAnyItems)
                  TextButton.icon(
                    onPressed: () => _showClearPlanDialog(context, budget, planProvider),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Budget Summary
            if (hasAnyItems)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Items',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${budget.selectedPlaces.length + planProvider.itemCount}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Cost',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${(budget.usedBudget + planProvider.totalBudget).toStringAsFixed(0)} EGP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            if (!hasAnyItems)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.event_note,
                      size: 60,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No items added yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore brands and add items to your plan',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // Menu Items Section
              if (hasMenuItems) ...[
                const Text(
                  'Menu Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...planProvider.planItems.asMap().entries.map((entry) {
                  final planItem = entry.value;
                  return _buildMenuPlanItem(context, planItem, planProvider);
                }).toList(),
                const SizedBox(height: 16),
              ],

              // Places Section
              if (hasPlaces) ...[
                const Text(
                  'Places',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...budget.selectedPlaces.asMap().entries.map((entry) {
                  final index = entry.key;
                  final place = entry.value;
                  return _buildPlanItem(context, place, index, budget);
                }).toList(),
              ],
              
              // Generate Smart Plan Button - AT THE BOTTOM
              if (hasAnyItems) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _generateSmartPlan(context, budget),
                  icon: const Icon(Icons.auto_awesome, size: 20),
                  label: const Text('Generate Smart Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _buildPlanItem(
    BuildContext context,
    Map<String, dynamic> place,
    int index,
    BudgetProvider budget,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.place,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'] ?? 'Place',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${place['price']} EGP',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () => budget.removePlaceFromPlan(index),
          ),
        ],
      ),
    );
  }

  void _setBudget(BuildContext context) {
    final total = double.tryParse(_budgetController.text) ?? 0;
    final min = double.tryParse(_minController.text) ?? 0;
    final max = double.tryParse(_maxController.text) ?? 0;

    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid budget'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final outingType = Provider.of<OutingTypeProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);

    // Set budget
    budgetProvider.setBudget(total, min, max);

    // Set participants
    final participantCount = _getParticipantCount(outingType, groupProvider);
    final participantNames = _getParticipantNames(outingType, groupProvider);
    budgetProvider.setParticipants(participantCount, participantNames);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Budget set for $participantCount ${participantCount == 1 ? "person" : "people"}!'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate to explore
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlacesListScreen(),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Budget'),
        content: const Text('Are you sure you want to reset your budget and clear your plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BudgetProvider>(context, listen: false).clearPlan();
              Provider.of<BudgetProvider>(context, listen: false).setBudget(0, 0, 0);
              Navigator.pop(context);
              _budgetController.clear();
              _minController.clear();
              _maxController.clear();
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuPlanItem(
    BuildContext context,
    PlanItem planItem,
    PlanProvider planProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: planItem.imageUrl != null
                ? Image.network(
                    planItem.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: AppColors.secondary,
                          size: 28,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: AppColors.secondary,
                      size: 28,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planItem.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${planItem.brandName} • ${planItem.branchName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${planItem.sizeDisplay} • Qty: ${planItem.quantity}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${planItem.totalPrice.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: () => planProvider.removeFromPlan(planItem.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearPlanDialog(BuildContext context, BudgetProvider budget, PlanProvider planProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Plan'),
        content: const Text('Are you sure you want to clear all items from your plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              budget.clearPlan();
              planProvider.clearPlan();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _generateSmartPlan(BuildContext context, BudgetProvider budget) {
    final generator = SmartPlanGenerator();
    final schedule = generator.generateDailyPlan(budget.selectedPlaces);

    if (schedule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No places to plan!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmartPlanScreen(
          schedule: schedule,
          totalBudget: budget.totalBudget,
        ),
      ),
    );
  }
}

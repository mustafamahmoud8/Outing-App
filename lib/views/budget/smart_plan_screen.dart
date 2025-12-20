import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/services/smart_plan_generator.dart';
import 'package:outing/providers/budget_provider.dart';
import 'package:outing/theme/app_colors.dart';

class SmartPlanScreen extends StatelessWidget {
  final List<ScheduleItem> schedule;
  final double totalBudget;

  const SmartPlanScreen({
    super.key,
    required this.schedule,
    required this.totalBudget,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = schedule.fold<double>(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Smart Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePlan(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Consumer<BudgetProvider>(
              builder: (context, budget, child) {
                final totalCost = schedule.fold<double>(0, (sum, item) => sum + item.price);
                final participantCount = budget.participantCount;
                final perPersonCost = participantCount > 0 ? totalCost / participantCount : totalCost;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Duration',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _getTotalDuration(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${totalCost.toStringAsFixed(0)} EGP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.place, color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${schedule.length} places planned',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        if (participantCount > 1)
                          Row(
                            children: [
                              const Icon(Icons.people, color: Colors.white70, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '$participantCount people',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (participantCount > 1) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${perPersonCost.toStringAsFixed(0)} EGP per person',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),

          // Timeline
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final item = schedule[index];
                final isLast = index == schedule.length - 1;

                return _buildTimelineItem(item, isLast);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Start Your Day!'),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(ScheduleItem item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getCategoryIcon(item.category),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: AppColors.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      item.timeRange,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.placeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.duration.inHours}h ${item.duration.inMinutes % 60}m',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${item.price.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('cafe') || cat.contains('coffee')) return '☕';
    if (cat.contains('restaurant') || cat.contains('food')) return '🍽️';
    if (cat.contains('museum')) return '🏛️';
    if (cat.contains('park')) return '🌳';
    if (cat.contains('shopping') || cat.contains('mall')) return '🛍️';
    if (cat.contains('cinema') || cat.contains('entertainment')) return '🎬';
    return '📍';
  }

  String _getTotalDuration() {
    if (schedule.isEmpty) return '0h';
    
    final start = schedule.first.startTime;
    final end = schedule.last.endTime;
    
    final totalMinutes = (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  void _sharePlan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plan shared!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

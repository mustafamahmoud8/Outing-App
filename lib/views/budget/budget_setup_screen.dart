import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/budget_provider.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/widgets/custom_button.dart';

class BudgetSetupScreen extends StatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final TextEditingController _totalBudgetController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    _totalBudgetController.text = budgetProvider.totalBudget > 0 
        ? budgetProvider.totalBudget.toString() 
        : '';
    _minPriceController.text = budgetProvider.minPricePerPlace > 0 
        ? budgetProvider.minPricePerPlace.toString() 
        : '';
    _maxPriceController.text = budgetProvider.maxPricePerPlace > 0 
        ? budgetProvider.maxPricePerPlace.toString() 
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.account_balance_wallet, size: 60, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Plan Your Perfect Day',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Set your budget and let us create the perfect itinerary for you',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Total Budget
            const Text(
              'Total Budget',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _totalBudgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter your total budget',
                prefixIcon: Icon(Icons.attach_money),
                suffixText: 'EGP',
              ),
            ),
            const SizedBox(height: 24),
            
            // Price Range
            const Text(
              'Price Range Per Place',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Min',
                      prefixIcon: Icon(Icons.remove_circle_outline),
                      suffixText: 'EGP',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Max',
                      prefixIcon: Icon(Icons.add_circle_outline),
                      suffixText: 'EGP',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We\'ll suggest places within your price range and create a smart daily plan that fits your budget perfectly!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                text: 'Save Budget',
                icon: Icons.check_circle,
                onPressed: () {
                  final total = double.tryParse(_totalBudgetController.text) ?? 0;
                  final min = double.tryParse(_minPriceController.text) ?? 0;
                  final max = double.tryParse(_maxPriceController.text) ?? 0;
                  
                  if (total > 0 && min > 0 && max > 0 && min <= max) {
                    Provider.of<BudgetProvider>(context, listen: false)
                        .setBudget(total, min, max);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Budget saved successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid budget values'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _totalBudgetController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
}

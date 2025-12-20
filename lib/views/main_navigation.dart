import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/views/home_screen.dart';
import 'package:outing/views/places/places_list_screen.dart';
import 'package:outing/views/budget/unified_budget_screen.dart';
import 'package:outing/views/chats/enhanced_ai_chat_screen.dart';
import 'package:outing/views/profile/profile_screen.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/providers/main_navigation_controller.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  DateTime? _lastBackPress;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const PlacesListScreen(),
    const UnifiedBudgetScreen(),
    const EnhancedAIChatScreen(),
    const ProfileScreen(),
  ];

  Future<bool> _onWillPop(int currentIndex) async {
    if (currentIndex != 0) {
      // If not on home screen, go back to home
      Provider.of<MainNavigationController>(context, listen: false).goToHome();
      return false;
    } else {
      // On home screen, check for double back press
      final now = DateTime.now();
      if (_lastBackPress == null ||
          now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
        _lastBackPress = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainNavigationController>(
      builder: (context, navController, _) {
        return WillPopScope(
          onWillPop: () => _onWillPop(navController.currentIndex),
          child: Scaffold(
            body: _screens[navController.currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: navController.currentIndex,
                onTap: (index) => navController.setIndex(index),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_outlined),
                    activeIcon: Icon(Icons.explore),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    activeIcon: Icon(Icons.account_balance_wallet),
                    label: 'Budget',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    activeIcon: Icon(Icons.chat_bubble),
                    label: 'AI Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

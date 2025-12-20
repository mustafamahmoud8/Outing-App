import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/favorites_provider.dart';
import 'package:outing/providers/main_navigation_controller.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/views/brands/brand_details_screen.dart';
import 'package:outing/providers/brands_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              if (favProvider.favoritesCount > 0) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear All',
                  onPressed: () => _showClearDialog(context, favProvider),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, child) {
          if (favProvider.favorites.isEmpty) {
            return _buildEmptyState();
          }

          return CustomScrollView(
            slivers: [
              // Header Stats
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        '${favProvider.favoritesCount}',
                        'Total Favorites',
                        Icons.favorite,
                      ),
                      _buildStatCard(
                        '${favProvider.getFavoritesByType('brand').length}',
                        'Brands',
                        Icons.business,
                      ),
                      _buildStatCard(
                        '${favProvider.getFavoritesByType('place').length}',
                        'Places',
                        Icons.place,
                      ),
                    ],
                  ),
                ),
              ),

              // Favorites List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final favorite = favProvider.favorites[index];
                      return _buildFavoriteCard(context, favorite, favProvider);
                    },
                    childCount: favProvider.favorites.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    FavoriteItem favorite,
    FavoritesProvider favProvider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: favorite.type == 'brand' 
                ? AppColors.primaryGradient
                : LinearGradient(
                    colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.7)],
                  ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: favorite.logo != null
                ? Text(
                    favorite.logo!,
                    style: const TextStyle(fontSize: 32),
                  )
                : Icon(
                    favorite.type == 'brand' ? Icons.business : Icons.place,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),
        title: Text(
          favorite.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (favorite.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  favorite.category!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatDate(favorite.addedAt),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (favorite.type == 'brand')
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                color: isDark ? Colors.white54 : AppColors.textSecondary,
                onPressed: () => _navigateToBrand(context, favorite.id),
              ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => favProvider.removeFavorite(favorite.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Favorites Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start adding your favorite places and brands',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to explore tab
                  Provider.of<MainNavigationController>(context, listen: false).goToExplore();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.explore),
                label: const Text('Explore Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Added today';
    } else if (difference.inDays == 1) {
      return 'Added yesterday';
    } else if (difference.inDays < 7) {
      return 'Added ${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Added $weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Added $months ${months == 1 ? "month" : "months"} ago';
    }
  }

  void _navigateToBrand(BuildContext context, String brandId) {
    final brandsProvider = Provider.of<BrandsProvider>(context, listen: false);
    final brand = brandsProvider.brands.firstWhere(
      (b) => b.id == brandId,
      orElse: () => brandsProvider.brands.first,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandDetailsScreen(brand: brand),
      ),
    );
  }

  void _showClearDialog(BuildContext context, FavoritesProvider favProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              favProvider.clearFavorites();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

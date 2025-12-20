import 'package:flutter/material.dart';
import 'package:outing/theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHelpTopic(
            context,
            'Getting Started',
            'Learn how to use Outing',
            Icons.rocket_launch,
            () => _showHelpDetail(context, 'Getting Started', _gettingStartedContent),
          ),
          _buildHelpTopic(
            context,
            'Budget Planning',
            'How to set and manage your budget',
            Icons.account_balance_wallet,
            () => _showHelpDetail(context, 'Budget Planning', _budgetPlanningContent),
          ),
          _buildHelpTopic(
            context,
            'Finding Places',
            'Discover amazing places near you',
            Icons.explore,
            () => _showHelpDetail(context, 'Finding Places', _findingPlacesContent),
          ),
          _buildHelpTopic(
            context,
            'AI Assistant',
            'Get personalized recommendations',
            Icons.auto_awesome,
            () => _showHelpDetail(context, 'AI Assistant', _aiAssistantContent),
          ),
          _buildHelpTopic(
            context,
            'Account Settings',
            'Manage your profile and preferences',
            Icons.settings,
            () => _showHelpDetail(context, 'Account Settings', _accountSettingsContent),
          ),
          _buildHelpTopic(
            context,
            'Dark Mode',
            'Switch between light and dark themes',
            Icons.dark_mode,
            () => _showHelpDetail(context, 'Dark Mode', _darkModeContent),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTopic(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showHelpDetail(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const String _gettingStartedContent = '''
Welcome to Outing! 🎉

Here's how to get started:

1. Set Your Budget
   - Go to Settings → Budget Setup
   - Enter your total budget
   - Set min/max price per place

2. Explore Places
   - Browse featured places on home screen
   - Use categories to filter
   - Search for specific locations

3. Add to Plan
   - Click on any place
   - Tap "Add to Plan"
   - Budget is automatically tracked

4. Generate Smart Plan
   - Go to Plans screen
   - Click "Generate Smart Plan"
   - Get AI-powered itinerary

5. Chat with AI
   - Navigate to Chats
   - Ask for recommendations
   - Get personalized suggestions

That's it! Start exploring amazing places near you! 🚀
''';

  static const String _budgetPlanningContent = '''
Budget Planning Made Easy 💰

Setting Your Budget:
1. Open Settings
2. Tap "Budget Setup"
3. Enter total budget amount
4. Set price range per place
5. Save your preferences

Tracking Your Budget:
- View budget summary on home screen
- See used vs remaining budget
- Get alerts when exceeding budget
- Budget updates automatically

Smart Planning:
- AI suggests places within budget
- Optimizes your spending
- Considers all preferences
- Generates balanced itinerary

Tips:
✓ Set realistic budget
✓ Include buffer for extras
✓ Review before finalizing
✓ Adjust as needed
''';

  static const String _findingPlacesContent = '''
Discover Amazing Places 🗺️

Search Methods:
1. Browse Categories
   - Restaurants
   - Cafes
   - Parks
   - Museums
   - Shopping

2. Use Search Bar
   - Type place name
   - Search by location
   - Filter by rating

3. Filter by Budget
   - Set price range
   - Filter by category
   - Sort by rating

4. Featured Places
   - Curated selections
   - Popular destinations
   - Trending spots

Place Details:
- View photos
- Read reviews
- Check ratings
- See location
- View amenities
- Compare prices

Actions:
✓ Add to favorites
✓ Add to plan
✓ Share with friends
✓ Get directions
''';

  static const String _aiAssistantContent = '''
AI-Powered Recommendations 🤖

What AI Can Do:
- Suggest places based on budget
- Create personalized itineraries
- Recommend similar places
- Optimize your plans
- Answer questions

How to Use:
1. Go to Chats screen
2. Type your question
3. Get instant recommendations
4. Follow suggestions

Example Questions:
"Find cafes under 100 EGP"
"Plan a day trip for 500 EGP"
"Recommend parks nearby"
"Best restaurants in Cairo"

Smart Features:
✓ Budget-aware suggestions
✓ Location-based results
✓ Preference learning
✓ Real-time responses

Tips:
- Be specific in questions
- Mention your budget
- Specify preferences
- Ask follow-up questions
''';

  static const String _accountSettingsContent = '''
Manage Your Account ⚙️

Profile Settings:
1. Edit Profile
   - Update name
   - Change email
   - Add phone number
   - Save changes

2. Change Password
   - Enter current password
   - Set new password
   - Confirm changes

3. Preferences
   - Enable notifications
   - Allow location access
   - Set language
   - Choose theme

Privacy & Security:
- Review privacy policy
- Manage data
- Control permissions
- Secure account

App Settings:
✓ Dark mode toggle
✓ Notification preferences
✓ Location services
✓ Data management

Need Help?
Contact support through:
- Help Center
- Email support
- In-app chat
''';

  static const String _darkModeContent = '''
Dark Mode 🌙

Benefits:
- Reduces eye strain
- Saves battery life
- Better for night use
- Modern appearance

How to Enable:
1. Go to Settings
2. Find "Dark Mode"
3. Toggle switch
4. Theme changes instantly

Features:
✓ Professional design
✓ Easy on eyes
✓ Consistent colors
✓ Smooth transitions

Automatic Switching:
- Follows system theme
- Saves preference
- Applies everywhere
- Instant updates

Customization:
The dark theme is carefully designed with:
- Optimized contrast
- Readable text
- Vibrant accents
- Comfortable colors

Try it now for a better viewing experience!
''';
}

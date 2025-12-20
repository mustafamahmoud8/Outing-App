import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outing/views/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:outing/providers/auth_provider.dart';
import 'package:outing/providers/offer_provider.dart';
import 'package:outing/providers/place_provider.dart';
import 'package:outing/providers/favorites_provider.dart';
import 'package:outing/providers/budget_provider.dart';
import 'package:outing/providers/theme_provider.dart';
import 'package:outing/providers/user_profile_provider.dart';
import 'package:outing/providers/brands_provider.dart';
import 'package:outing/providers/connectivity_provider.dart';
import 'package:outing/providers/owner_places_provider.dart';
import 'package:outing/providers/history_provider.dart';
import 'package:outing/providers/language_provider.dart';
import 'package:outing/providers/outing_type_provider.dart';
import 'package:outing/providers/group_provider.dart';
import 'package:outing/providers/plan_provider.dart';
import 'package:outing/providers/main_navigation_controller.dart';
import 'package:outing/views/main_navigation.dart';
import 'package:outing/views/onboarding/permissions_screen.dart';
import 'package:outing/views/join_us/join_us_screen.dart';
import 'package:outing/widgets/connectivity_banner.dart';
import 'package:outing/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Notifications
  await NotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => BudgetProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => BrandsProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => OwnerPlacesProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => OutingTypeProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
        ChangeNotifierProvider(create: (context) => PlanProvider()),
        ChangeNotifierProvider(create: (context) => MainNavigationController()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          return MaterialApp(
            title: 'Outing',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/': (context) => ConnectivityBanner(
                    child: FutureBuilder<bool>(
                      future: _checkFirstLaunch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final bool permissionsRequested = snapshot.data ?? false;

                        if (!permissionsRequested) {
                          return const PermissionsScreen();
                        }

                        return Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            if (authProvider.isAuthenticated) {
                              return const MainNavigation();
                            } else {
                              return const LoginScreen();
                            }
                          },
                        );
                      },
                    ),
                  ),
              '/join-us': (context) => const JoinUsScreen(),
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('permissionsRequested') ?? false;
  }
}

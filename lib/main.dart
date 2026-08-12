
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'player_data.dart';
import 'user_storage.dart';
import 'app_language.dart';
import 'social_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/license_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GoldenSystemApp());
}

class GoldenSystemApp extends StatefulWidget {
  const GoldenSystemApp({super.key});

  @override
  State<GoldenSystemApp> createState() => _GoldenSystemAppState();
}

class _GoldenSystemAppState extends State<GoldenSystemApp> {
  bool loading = true;
  bool registered = false;
  Map<String, dynamic>? savedData;
  Locale _locale = const Locale('ar');

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('app_language') ?? 'ar';
    _locale = Locale(code);
    await _checkAccount();
  }

  Future<void> _checkAccount() async {
    final data = await UserStorage.load();

    if (data != null && data['registered'] == true) {
      savedData = data;
      registered = true;
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> _handleRegistrationComplete() async {
    final data = await UserStorage.load();
    if (!mounted || data == null || data['registered'] != true) return;
    setState(() {
      savedData = data;
      registered = true;
    });
  }

  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', code);
    if (mounted) {
      setState(() => _locale = Locale(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale,
        home: const SplashScreen(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('fr'),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC83D),
          brightness: Brightness.dark,
        ),
      ),
      home: registered
          ? MainNavigation(
              data: savedData!,
              currentLocale: _locale,
              onLanguageChanged: changeLanguage,
            )
          : RegisterScreen(
              onRegistered: _handleRegistrationComplete,
            ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final Map<String, dynamic> data;
  final Locale currentLocale;
  final Future<void> Function(String code)? onLanguageChanged;

  const MainNavigation({
    super.key,
    required this.data,
    required this.currentLocale,
    this.onLanguageChanged,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  static const gold = Color(0xFFFFC83D);

  int currentIndex = 0;
  late PlayerData player;

  File? profileImage;
  File? licenseImage;

  int goldBalance = 1500;
  int diamonds = 250;
  int currentLevel = 1;
  final List<int> ownedLevels = [1];

  @override
  void initState() {
    super.initState();
    player = PlayerData.fromMap(widget.data);
    _loadImages();
    _loadBalances();
  }

  void _loadImages() {
    final profilePath = widget.data['profileImagePath']?.toString();
    final licensePath = widget.data['licenseImagePath']?.toString();

    if (profilePath != null && profilePath.isNotEmpty) {
      final file = File(profilePath);
      if (file.existsSync()) profileImage = file;
    }

    if (licensePath != null && licensePath.isNotEmpty) {
      final file = File(licensePath);
      if (file.existsSync()) licenseImage = file;
    }
  }


  Future<void> _loadBalances() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      goldBalance = prefs.getInt('gold_balance') ?? 1500;
      diamonds = prefs.getInt('diamonds_balance') ?? 250;
    });
  }

  AppLanguage get appLanguage {
    switch (widget.currentLocale.languageCode) {
      case 'en':
        return AppLanguage.english;
      case 'fr':
        return AppLanguage.french;
      default:
        return AppLanguage.arabic;
    }
  }

  String _languageCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.arabic:
        return 'ar';
      case AppLanguage.english:
        return 'en';
      case AppLanguage.french:
        return 'fr';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        playerName: player.playerName,
        characterName: player.characterName,
        profileImage: profileImage,
      ),
      SocialScreen(
        playerName: player.playerName,
        playerId: player.playerId,
      ),
      ShopScreen(
        goldBalance: goldBalance,
        diamonds: diamonds,
        currentLevel: currentLevel,
      ),
      LicenseScreen(
        ownedLevels: ownedLevels,
        activeLevel: currentLevel,
        onLevelChanged: (level) {
          setState(() => currentLevel = level);
        },
      ),
      ProfileScreen(
        playerName: player.playerName,
        characterName: player.characterName,
        playerId: player.playerId,
        profileImage: profileImage,
        licenseImage: licenseImage,
        currentLanguage: appLanguage,
        onLanguageChanged: (language) {
          widget.onLanguageChanged?.call(_languageCode(language));
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0B0B0B),
        indicatorColor: const Color(0x33FFC83D),
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: gold),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded, color: gold),
            label: 'الأصدقاء',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded, color: gold),
            label: 'المتجر',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded, color: gold),
            label: 'الرخص',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: gold),
            label: 'الملف',
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/golden_system.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFFFC83D),
                  size: 130,
                );
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'المطور : Mohmed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFFFC83D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel_app/data/provider/auth_provider.dart';
import 'package:flutter_novel_app/data/provider/author_provider.dart';
import 'package:flutter_novel_app/data/provider/category_provider.dart';
import 'package:flutter_novel_app/data/provider/chapter_provider.dart';
import 'package:flutter_novel_app/data/provider/comment_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_featured_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/data/provider/reading_provider.dart';
import 'package:flutter_novel_app/data/provider/review_provider.dart';
import 'package:flutter_novel_app/data/provider/favorite_provider.dart';
import 'package:flutter_novel_app/data/provider/user_provider.dart';
import 'package:flutter_novel_app/screens/auth/login_screen.dart';
import 'package:flutter_novel_app/screens/auth/register_screen.dart';
import 'package:flutter_novel_app/screens/auth/verify_screen.dart';
import 'package:flutter_novel_app/screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart' as explore;
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('id_ID', null);
  await Hive.openBox<List>('favoriteBox');
  await dotenv.load(fileName: ".env");
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NovelProvider()),
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => NovelFeaturedProvider()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Novel App',
        navigatorKey: MyApp.navigatorKey,
        routes: {
          '/login': (context) =>   LoginScreen(),
          '/register': (context) =>   SignUpScreen(),
          '/verify': (context) =>   OtpVerificationScreen(),
          '/main': (context) =>   MainScreen(),
          '/profile': (context) =>   ProfileScreen(),
          '/explore': (context) =>   explore.ExploreScreen(),
          '/saved': (context) =>   SavedScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF5F4ED),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F4ED),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF005753)),
            titleTextStyle: TextStyle(
              color: Color(0xFF005753),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: Color(0xFF005753),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: Color(0xFF005753),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              color: Color(0xFF005753),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Color(0xFF005753),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005753),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF005753),
              side: const BorderSide(color: Color(0xFF005753)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF005753), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  static final List<Widget> _screens = [
    const HomeScreen(),
    const explore.ExploreScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animation),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4ED),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.search, 'Explore'),
                  _buildNavItem(2, Icons.bookmark, 'Simpan'),
                  _buildNavItem(3, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? 40 : 30,
              width: isSelected ? 40 : 30,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF005753).withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF005753) : Colors.grey,
                size: isSelected ? 24 : 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF005753) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

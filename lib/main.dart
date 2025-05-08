import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel_app/data/provider/author_provider.dart';
import 'package:flutter_novel_app/data/provider/category_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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

      ],
      child: MaterialApp(
        title: 'Novel App',
        navigatorKey: navigatorKey,
         routes: {
          // '/': (context) =>   MainScreen(),
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
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScren(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF5F4ED),
        selectedItemColor: const Color(0xFF005753),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Simpan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

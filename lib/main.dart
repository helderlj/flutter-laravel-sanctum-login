import 'package:authentication_app_laravel_sanctum/components/splash.dart';
import 'package:authentication_app_laravel_sanctum/pages/categories_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/home_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/login_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/playlists_page.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
import 'package:authentication_app_laravel_sanctum/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const SplashScreen());
  bool? isLoggedIn = false;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool("isLoggedIn");
  print("Função Main(), verificado estado do login no armazenamento interno");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(isLoggedIn: isLoggedIn ?? false))
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final storage = const FlutterSecureStorage();

  void _attemptAuthFromStoredToken() async {
    String? token = await storage.read(key: 'auth-token');
    if (mounted) {
      if (token != null) {
        Provider.of<AuthProvider>(context, listen: false).attempt(token);
      }
    }
  }

  @override
  void initState() {
    _attemptAuthFromStoredToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var home = Provider.of<AuthProvider>(context).isLoggedIn
        ? const HomePage()
        : const LoginPage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/categories': (context) => const CategoriesPage(),
        // '/category': (context) => const CategoryPage(),
        '/playlists': (context) => const PlaylistsPage(),
        // '/albums': (context) => const AlbumsPage(),
      },
    );
  }
}

import 'dart:convert';

import 'package:authentication_app_laravel_sanctum/components/splash.dart';
import 'package:authentication_app_laravel_sanctum/models/Setting.dart';
import 'package:authentication_app_laravel_sanctum/pages/categories_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/home_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/login_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/playlists_page.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
import 'package:authentication_app_laravel_sanctum/providers/settings_provider.dart';
import 'package:authentication_app_laravel_sanctum/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const SplashScreen());
  bool? isLoggedIn = false;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool("isLoggedIn");

  Settings settings =
      Settings.fromJson(json.decode(prefs.getString("settings") ?? "{}"));

  print("Função Main(), verificado estado do login no armazenamento interno");

  ThemeData theme = ThemeData(
    primaryColor: settings.primColor,
    secondaryHeaderColor: settings.secColor,
    colorScheme: ColorScheme.fromSeed(seedColor: settings.primColor),
    textTheme: GoogleFonts.robotoMonoTextTheme(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider(settings)),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(isLoggedIn: isLoggedIn ?? false))
      ],
      child: MainApp(theme: theme),
    ),
  );
}

class MainApp extends StatefulWidget {
  MainApp({super.key, required this.theme});
  ThemeData theme;

  @override
  State<MainApp> createState() => _MainAppState(theme: theme);
}

class _MainAppState extends State<MainApp> {
  ThemeData theme;

  final storage = const FlutterSecureStorage();

  void _attemptAuthFromStoredToken() async {
    String? token = await storage.read(key: 'auth-token');
    if (mounted) {
      if (token != null) {
        Provider.of<AuthProvider>(context, listen: false).attempt(token);
      }
    }
  }

  void _fetchRemoteSettingsFromApi() async {
    bool? isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool("isLoggedIn");

    // se logado, buscar as configurações locais
    if (isLoggedIn != null) {
      print("isLoggedIn diferente de null");
      if (isLoggedIn) {
        print("isLoggedIn true");
        String? sett = await prefs.getString('settings');
        if (sett != null) {
          print("Usuario logado: Settings carregadas do armazenamento local");
          Settings settings = Settings.fromJson(json.decode(sett));

          // alimentar o settingsProvider com as settings obtidas
          Provider.of<SettingsProvider>(context, listen: false).settings =
              settings;
        } else {
          // buscar remotamente
          var response = await dioService().get('settings');
          if (response.statusCode == 200) {
            Settings settings =
                Settings.fromJson(json.decode(response.toString()));
            print(json.encode(settings.mainLogo.toString()));
            prefs.setString('settings', json.encode(settings.toJson()));
            Provider.of<SettingsProvider>(context, listen: false).settings =
                settings;
          }
          print(
              "Usuario logado: Settings carregadas remotamente pois nao foram encontradas no armazenamento local");
        }
      } else {
        print("isLoggedIn false");
        // senao buscar remotamente
        var response = await dioService().get('settings');
        if (response.statusCode == 200) {
          Settings settings =
              Settings.fromJson(json.decode(response.toString()));
          prefs.setString('settings', json.encode(settings.toJson()));
          print("Settings obtidas remotamente e armazenadas localmente");
        }
      }
    }
  }

  _MainAppState({
    required this.theme,
  });

  @override
  void initState() {
    _fetchRemoteSettingsFromApi();
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
      theme: theme,
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

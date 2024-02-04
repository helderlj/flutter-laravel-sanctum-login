import 'package:authentication_app_laravel_sanctum/components/nav_drawer.dart';
import 'package:authentication_app_laravel_sanctum/pages/login_page.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
import 'package:authentication_app_laravel_sanctum/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;

    var settings = Provider.of<SettingsProvider>(context).settings;

    if (!isLoggedIn) {
      return LoginPage();
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          "H O M E",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Image.network(settings.mainLogo),
      ),
    );
  }
}

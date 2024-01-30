import 'package:authentication_app_laravel_sanctum/components/nav_drawer.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
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
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          "H O M E",
          style: TextStyle(color: Colors.purple[100]),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, value, child) {
            if (value.isLoggedIn) {
              return Text("Logado");
            } else {
              return Text("Deslogado");
            }
          },
        ),
      ),
    );
  }
}

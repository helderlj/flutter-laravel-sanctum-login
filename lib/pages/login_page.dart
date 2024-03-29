import 'package:authentication_app_laravel_sanctum/constants/default_settings.dart';
import 'package:authentication_app_laravel_sanctum/models/Setting.dart';
import 'package:authentication_app_laravel_sanctum/pages/home_page.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
import 'package:authentication_app_laravel_sanctum/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override

  /// Builds the login page UI.
  ///
  /// Returns a [Scaffold] with the login form if the user is not logged in yet.
  /// Checks [AuthProvider.isLoggedIn] to determine login state.
  /// Shows login error from [AuthProvider.authError] if available.
  /// Saves entered email and password via [_email] and [_password] state.
  /// Calls [submit] method on form submit to login.
  /// Navigates to [HomePage] if login succeeds.
  /// Builds the login page UI.
  ///
  /// Returns a [Scaffold] with the login form if the user is not logged in yet.
  /// Checks [AuthProvider.isLoggedIn] to determine login state.
  /// Shows login error from [AuthProvider.authError] if available.
  /// Saves entered email and password via [_email] and [_password] state.
  /// Calls [submit] method on form submit to login.
  /// Navigates to [HomePage] if login succeeds.
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    String? error = Provider.of<AuthProvider>(context).authError;
    Settings settings = Provider.of<SettingsProvider>(context).settings;

    print("isLoggedIn $isLoggedIn");

    if (isLoggedIn) {
      return HomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "L O G I N",
          style: TextStyle(
            color: settings.secColor,
          ),
        ),
        backgroundColor: settings.primColor,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Scrollbar(
              child: Column(
                children: [
                  Container(
                      child: Image.network(
                        settings.mainLogo,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(mainLogo),
                      ),
                      height: 250),
                  TextFormField(
                    initialValue: "admin@admin.com",
                    decoration: InputDecoration(
                      label: Text("Email"),
                      hintText: "email@empresa.com",
                      labelStyle: TextStyle(color: settings.primColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: settings.primColor),
                      ),
                    ),
                    onSaved: (newValue) => _email = newValue,
                    validator: (value) {
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(value!)) {
                        return 'Insira um email válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: "1234",
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Senha"),
                      labelStyle: TextStyle(color: settings.primColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: settings.primColor),
                      ),
                    ),
                    onSaved: (newValue) => _password = newValue,
                    validator: (value) {
                      if (value!.length < 5) {
                        return 'A senha precisa ter pelo menos 5 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    error ?? "",
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settings.primColor,
                        foregroundColor: settings.secColor,
                      ),
                      onPressed: () {
                        _formKey.currentState?.save();
                        submit();
                      },
                      child: Text("Entrar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    Provider.of<AuthProvider>(context, listen: false)
        .login(credentials: {'email': _email, 'password': _password});
    setState(() {});
  }
}

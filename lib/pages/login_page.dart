import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "L O G I N",
          style: TextStyle(
            color: Colors.purple[100],
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Scrollbar(
              child: Column(
                children: [
                  FlutterLogo(
                    size: 200,
                  ),
                  TextFormField(
                    initialValue: "admin@admin.com",
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      hintText: "email@empresa.com",
                    ),
                    onSaved: (newValue) => _email = newValue,
                  ),
                  TextFormField(
                    initialValue: "1234",
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Senha"),
                    ),
                    onSaved: (newValue) => _password = newValue,
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: () {
                        // Provider.of<AuthProvider>(context, listen: false)
                        //     .attemptToLogin();
                        // Navigator.pop(context);
                        // Navigator.pushNamed(context, '/home');
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
  }
}

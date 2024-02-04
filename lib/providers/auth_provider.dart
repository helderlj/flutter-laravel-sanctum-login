/// Provides authentication functionality for an app. Manages user login state, authentication tokens,
/// user information from a server, and persistence of auth tokens. Includes methods for login, logout,
/// retrieving auth tokens, validating tokens, and getting user info. Notifies listeners on auth state changes.
/// Provides authentication functionality. Manages user login state, tokens,
/// and communication with authentication server. Exposes login(), logout(),
/// and user info. Handles persistence of auth token.
import 'dart:convert';

import 'package:authentication_app_laravel_sanctum/models/User.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dio_service.dart';

/// Logs the user out by setting [_loggedIn] to false,
/// deleting the token, and notifying listeners.

class AuthProvider extends ChangeNotifier {
  late User _user;
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;
  User get user => _user;
  final storage = new FlutterSecureStorage();
  String? authError;

  Future login({Map? credentials}) async {
    String deviceId = await getDeviceId();
    print(deviceId);

    try {
      dioPackage.Response response = await dioService().post(
        'login',
        data: jsonEncode(
          credentials?..addAll({'deviceId': deviceId}),
        ),
      );

      if (response.statusCode == 200) {
        String token = json.decode(response.toString())['token'];
        await attempt(token);
        storeToken(token);
        authError = null;
        notifyListeners();
        print("metodo login - token obtido da api externa");
      } else {
        print(response.statusCode.toString());
        // print(response.data.toString());
        authError = jsonDecode(response.data)['message'];
        notifyListeners();
      }
    } on dioPackage.DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data.toString());
        // print(e.response?.headers.toString());
        // print(e.response?.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
  }

  Future attempt(String token) async {
    try {
      dioPackage.Response response = await dioService().get(
        'user',
        options: dioPackage.Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      _user = User.fromJson(json.decode(response.toString()));
      _loggedIn = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      notifyListeners();
      print("metodo attempt - token ja emitido validado na api externa");
    } on dioPackage.DioException catch (e) {
      _loggedIn = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", false);
      print("metodo attempt - exception");
    }
  }

  void logout() async {
    _loggedIn = false;
    notifyListeners();
    String? token = await getToken();
    try {
      await dioService().delete('logout',
          data: {'deviceId': await getDeviceId()},
          options: dioPackage.Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      print("metodo logout - token removido da api remota");
    } on Exception catch (e) {
      print("metodo logout - exception");
    }
    deleteToken();
  }

  void storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await storage.write(key: 'auth-token', value: token);
  }

  Future getToken() async {
    print("Token lido do armazenamento interno");
    return await storage.read(key: 'auth-token');
  }

  void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await storage.delete(key: 'auth-token');
    notifyListeners();
    print("Metodo deleteToken executado");
  }

  AuthProvider({isLoggedIn}) {
    _loggedIn = isLoggedIn;
    print("AuthProvider instanciado");
  }

  Future getDeviceId() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print("Device id recuperado");
    } catch (e) {
      //
    }
    return deviceId;
  }
}

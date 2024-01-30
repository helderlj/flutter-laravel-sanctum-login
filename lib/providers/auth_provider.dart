import 'dart:convert';

import 'package:authentication_app_laravel_sanctum/models/User.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../services/dio_service.dart';

class AuthProvider extends ChangeNotifier {
  late User _user;
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;
  User get user => _user;
  final storage = new FlutterSecureStorage();

  Future login({Map? credentials}) async {
    String deviceId = await getDeviceId();
    print(deviceId);
    dioPackage.Response response = await dioService().post(
      'login',
      data: jsonEncode(credentials?..addAll({'deviceId': deviceId})),
    );
    String token = json.decode(response.toString())['token'];
    print("token obtido");
    await attempt(token);
    storeToken(token);
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
      notifyListeners();
      print("Usuario recuperado");
    } on Exception catch (e) {
      _loggedIn = false;
      print(e.toString());
    }
  }

  void logout() async {
    _loggedIn = false;
    String token = await getToken();

    try {
      await dioService().delete('logout',
          data: {'deviceId': await getDeviceId()},
          options: dioPackage.Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
    } on Exception catch (e) {
      print(e);
    }
    deleteToken();
    notifyListeners();
  }

  void storeToken(String token) async {
    await storage.write(key: 'auth-token', value: token);
  }

  Future getToken() async {
    return await storage.read(key: 'auth-token');
  }

  void deleteToken() async {
    await storage.delete(key: 'auth-token');
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

import 'package:authentication_app_laravel_sanctum/models/Setting.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  late Settings _settings;

  bool dbInitialized = false;

  Settings get settings => _settings;

  // criar um setter
  set settings(Settings settings) {
    _settings = settings;
    notifyListeners();
  }

  SettingsProvider(Settings settings) {
    _settings = settings;
    print("SettingsProvider()");
    // prefs.setBool("dbInitialized", true);
  }
}

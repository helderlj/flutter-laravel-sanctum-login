import 'package:authentication_app_laravel_sanctum/models/Setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late Settings _settings;
  SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;

  bool inited = false;


  
}

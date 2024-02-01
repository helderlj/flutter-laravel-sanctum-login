// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Settings settingFromJson(String str) => Settings.fromJson(json.decode(str));

String settingToJson(Settings data) => json.encode(data.toJson());

class Settings {
  String mainLogo;
  String primaryLogo;
  String secondaryLogo;
  String primaryColor;
  String secondaryColor;

  Color get primColor {
    var hexString = primaryColor;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color get secColor {
    var hexString = secondaryColor;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Settings({
    required this.mainLogo,
    required this.primaryLogo,
    required this.secondaryLogo,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        mainLogo: json["main_logo"],
        primaryLogo: json["primary_logo"],
        secondaryLogo: json["secondary_logo"],
        primaryColor: json["primary_color"],
        secondaryColor: json["secondary_color"],
      );

  Map<String, dynamic> toJson() => {
        "main_logo": mainLogo,
        "primary_logo": primaryLogo,
        "secondary_logo": secondaryLogo,
        "primary_color": primaryColor,
        "secondary_color": secondaryColor,
      };
}

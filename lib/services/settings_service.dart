import "dart:convert";

import "package:authentication_app_laravel_sanctum/models/Setting.dart";
import "package:http/http.dart" as http;

class SettingsService {
  static const BASE_URL = "https://spotiphis.graphis.dev.br/api/settings";

  static Future<Setting> getSettinsFromApi() async {
    final response = await http.get(Uri.parse(BASE_URL));
    return response.statusCode == 200
        ? Setting.fromJson(jsonDecode(response.body))
        : throw Exception('Falha ao carregar dados');
  }
}

// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  int id;
  String title;
  String coverPath;
  // List<dynamic> albums;
  // List<dynamic> playlists;

  Category({
    required this.id,
    required this.title,
    required this.coverPath,
    // required this.albums,
    // required this.playlists,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["category"],
        coverPath: json["cover_path"],
        // albums: List<dynamic>.from(json["albums"].map((x) => x)),
        // playlists: List<dynamic>.from(json["playlists"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": title,
        "cover_path": coverPath,
        // "albums": List<dynamic>.from(albums.map((x) => x)),
        // "playlists": List<dynamic>.from(playlists.map((x) => x)),
      };
}

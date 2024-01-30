import 'package:authentication_app_laravel_sanctum/models/Category.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: Container(
          height: 200,
          child: Center(
            child: Image.network(category.coverPath),
          )),
    );
  }
}

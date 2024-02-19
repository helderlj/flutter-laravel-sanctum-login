import 'package:authentication_app_laravel_sanctum/models/Category.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Hero(
              tag: category.id,
              child: Image.network(category.coverPath),
            ),
          )),
    );
  }
}

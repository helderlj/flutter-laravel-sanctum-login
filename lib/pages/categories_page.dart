import 'dart:convert';

import 'package:authentication_app_laravel_sanctum/components/nav_drawer.dart';
import 'package:authentication_app_laravel_sanctum/models/Category.dart' as Cat;
import 'package:authentication_app_laravel_sanctum/models/Category.dart';
import 'package:authentication_app_laravel_sanctum/pages/category_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dioPackage;
import '../services/dio_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Future<List<Cat.Category>> _fetchCategories() async {
    dioPackage.Response response = await dioService().get('categories',
        options: dioPackage.Options(headers: {
          'auth': true,
        }));
    List categories = json.decode(response.toString());
    return categories.map((cat) => Cat.Category.fromJson(cat)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "C A T E G O R I A S",
          style: TextStyle(color: Colors.purple[100]),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const NavDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _fetchCategories();
          });
        },
        child: Center(
          child: FutureBuilder<List<Cat.Category>>(
            future: _fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Category category = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(snapshot.data![index].coverPath),
                      title: Text(snapshot.data![index].title),
                      contentPadding: EdgeInsets.all(10),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryPage(category: category),
                            ));
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text("falha ao carregar dados");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:authentication_app_laravel_sanctum/pages/categories_page.dart';
import 'package:authentication_app_laravel_sanctum/pages/home_page.dart';
import 'package:authentication_app_laravel_sanctum/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoggedIn) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  currentAccountPictureSize: const Size(50, 50),
                  currentAccountPicture: const FlutterLogo(),
                  accountEmail: Text(auth.user.email,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                  accountName: Text(auth.user.name,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: const Text("Home"),
                        leading: Icon(Icons.home,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ),
                      ListTile(
                        title: Text("Playlists"),
                        leading: Icon(Icons.list,
                            color: Theme.of(context).primaryColor),
                      ),
                      ListTile(
                          title: Text("Albums"),
                          leading: Icon(
                            Icons.music_note_outlined,
                            color: Theme.of(context).primaryColor,
                          )),
                      ListTile(
                        title: const Text("Categorias"),
                        leading: Icon(Icons.label,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CategoriesPage()));
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Logout"),
                        leading: Icon(Icons.logout,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return ListView(
              children: [
                const ListTile(title: Text("Item 1")),
              ],
            );
          }
        },
      ),
    );
  }
}

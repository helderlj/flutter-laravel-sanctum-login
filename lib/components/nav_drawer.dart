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
                  currentAccountPictureSize: const Size(50, 50),
                  currentAccountPicture: const FlutterLogo(),
                  accountEmail: Text(auth.user.email),
                  accountName: Text(auth.user.name),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: const Text("Home"),
                        leading: const Icon(Icons.home),
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                      ),
                      const ListTile(
                        title: Text("Playlists"),
                        leading: Icon(Icons.list),
                      ),
                      const ListTile(
                          title: Text("Albums"),
                          leading: Icon(Icons.music_note_outlined)),
                      ListTile(
                        title: const Text("Categorias"),
                        leading: const Icon(Icons.label),
                        onTap: () {
                          Navigator.of(context).pushNamed('/categories');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Logout"),
                        leading: const Icon(Icons.logout),
                        onTap: () {
                          // Navigator.pop(context);
                          // Navigator.pushNamed(context, '/login');
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                          // Navigator.pop(context);
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

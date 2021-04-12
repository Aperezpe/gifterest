import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/custom_list_tile.dart';
import 'package:bonobo/ui/screens/favorites/favorites_page.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({@required this.currentChildRouteName});

  final String currentChildRouteName;

  bool isSameRoute(String routeName) => currentChildRouteName == routeName;

  void _openRoute(
    BuildContext context, {
    @required String routeName,
    @required Widget child,
  }) {
    if (isSameRoute(routeName))
      Scaffold.of(context).openEndDrawer();
    else
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => child),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthBase, Database>(
      builder: (_, auth, database, __) => Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: () => _openRoute(
                context,
                routeName: MyProfilePage.routeName,
                child: MyProfilePage(),
              ),
              child: Container(
                width: double.infinity,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.pink,
                        Colors.orange,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: _buildUserAvatar(auth),
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  CustomListTile(
                    title: "My Friends",
                    icon: Icons.people,
                    onTap: () => _openRoute(
                      context,
                      routeName: MyFriendsPage.routeName,
                      child: MyFriendsPage(),
                    ),
                  ),
                  CustomListTile(
                    title: "Favorites",
                    icon: Icons.favorite,
                    onTap: () => _openRoute(
                      context,
                      routeName: FavoritesPage.routeName,
                      child: FavoritesPage(),
                    ),
                  ),
                  CustomListTile(
                    title: "Sign Out",
                    icon: Icons.power_settings_new,
                    onTap: () => auth.signOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AuthBase auth) {
    return Container(
      child: FutureBuilder<User>(
        future: auth.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: user.photoURL == null
                      ? AssetImage('assets/placeholder.jpg')
                      : NetworkImage(user.photoURL),
                ),
                SizedBox(height: 15),
                Text(
                  user.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print("Drawer error: ${snapshot.error}");
          }
          return CircleAvatar(
            radius: 45,
          );
        },
      ),
    );
  }
}

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/common_widgets/custom_list_tile.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/favorites/favorites_page.dart';
import 'package:gifterest/ui/screens/my_friends/my_friends_page.dart';
import 'package:gifterest/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:gifterest/ui/screens/settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

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
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Consumer2<AuthBase, Database>(
      builder: (_, auth, database, __) => Container(
        width: is700Wide
            ? SizeConfig.blockSizeHorizontal * 50
            : SizeConfig.blockSizeHorizontal * 70,
        child: Drawer(
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
                    margin: EdgeInsets.only(bottom: 0),
                    padding:
                        EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                    ),
                    child: _buildHeader(database),
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
                      icon: LineIcons.gift,
                      onTap: () => _openRoute(
                        context,
                        routeName: MyFriendsPage.routeName,
                        child: MyFriendsPage(),
                      ),
                    ),
                    CustomListTile(
                      title: "Favorites",
                      icon: LineIcons.heart,
                      onTap: () => _openRoute(
                        context,
                        routeName: FavoritesPage.routeName,
                        child: FavoritesPage(),
                      ),
                    ),
                    CustomListTile(
                      title: "Settings",
                      icon: LineIcons.cog,
                      onTap: () => _openRoute(
                        context,
                        routeName: SettingsPage.routeName,
                        child: SettingsPage(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FirestoreDatabase database) {
    return StreamBuilder<Person>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${user.name}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        offset: Offset(1, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    fontSize: SizeConfig.titleSize,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical),
                Text(
                  "See your profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.subtitleSize,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print("Drawer error: ${snapshot.error}");
        }

        return Container();
      },
    );
  }
}

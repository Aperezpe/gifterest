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
              Container(
                width: double.infinity,
                child: DrawerHeader(
                  margin: EdgeInsets.only(bottom: 0),
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffF6821F), Color(0xffE11382)],
                      stops: [0.5, 1],
                      end: Alignment.bottomLeft,
                      begin: Alignment.topRight,
                    ),
                  ),
                  child: _buildHeader(),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    CustomListTile(
                      title: "My Profile",
                      icon: LineIcons.user,
                      onTap: () => _openRoute(
                        context,
                        routeName: MyProfilePage.routeName,
                        child: MyProfilePage(),
                      ),
                    ),
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

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Flexible(child: Image.asset("assets/logo_transpa.png")),
          // Text(
          //   "Gifterest",
          //   style: TextStyle(
          //       fontSize: SizeConfig.h3Size,
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
}

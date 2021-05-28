import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/custom_list_tile.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/favorites/favorites_page.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/my_profile/my_profile_page.dart';
import 'package:flutter/material.dart';
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
                  height: is700Wide
                      ? SizeConfig.safeBlockVertical * 22
                      : SizeConfig.safeBlockVertical * 29,
                  child: DrawerHeader(
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                    ),
                    // Uncomment for radial gradient
                    // decoration: BoxDecoration(
                    //   gradient: RadialGradient(
                    //     colors: <Color>[
                    //       Color(0xffffcc00).withOpacity(.8),
                    //       Colors.red,
                    //       // Color(0xfffb997f),
                    //       // Color(0xfff47199),
                    //     ],
                    //     center: Alignment(0, -1),
                    //     radius: 1.4,

                    //     // stops: [0, .8],
                    //     // begin: Alignment(.5, 0),
                    //     // end: Alignment(.7, 1),
                    //   ),
                    // ),
                    child: _buildUserAvatar(database),
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
                      title: "Sign Out",
                      icon: LineIcons.alternateSignOut,
                      onTap: () => auth.signOut(),
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

  Widget _buildUserAvatar(FirestoreDatabase database) {
    final is700Wide = SizeConfig.screenWidth >= 700;

    final avatarRadius = is700Wide
        ? SizeConfig.safeBlockVertical * 5
        : SizeConfig.safeBlockVertical * 6.5;
    return StreamBuilder<Person>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return Column(
            children: [
              // TODO: Poner un changuito o algo envez de un placeholder
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: AssetImage('assets/placeholder.jpg'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
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
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "See your profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.subtitleSize,
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          print("Drawer error: ${snapshot.error}");
        }
        return CircleAvatar(
          radius: avatarRadius,
        );
      },
    );
  }
}

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/ui/app_drawer.dart';
import 'package:gifterest/ui/common_widgets/custom_app_bar.dart';
import 'package:gifterest/ui/common_widgets/drawer_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/screens/sign_in/terms_and_conditions.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  static String get routeName => 'settings-page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;

  Future<void> _onAsyncMethod(Future<void> method, {bool load = true}) async {
    if (load) {
      setState(() => isLoading = true);
      try {
        await method;
      } catch (e) {
        print(e);
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      await method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    SizeConfig().init(context);

    final menu = <Widget>[
      ListTile(
        title: Text("Terms & Conditions"),
        onTap: () => _onAsyncMethod(
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => TermsOrDisclosure(),
            ),
          ),
          load: false,
        ),
      ),
      ListTile(
        title: Text("Affiliate Disclaimer"),
        onTap: () => _onAsyncMethod(
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => TermsOrDisclosure(isTerms: false),
            ),
          ),
          load: false,
        ),
      ),
      ListTile(
        title: Text("Sign Out"),
        onTap: () => _onAsyncMethod(auth.signOut()),
      ),
      // ListTile(
      //   title: Text("Load"),
      //   onTap: () => _onAsyncMethod(Future.delayed(Duration(seconds: 2))),
      // ),
    ];

    return AbsorbPointer(
      absorbing: isLoading,
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
              title: "Settings",
              leading: DrawerButtonBuilder(),
            ),
            drawer: AppDrawer(currentChildRouteName: SettingsPage.routeName),
            body: ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemCount: menu.length + 1,
              itemBuilder: (context, index) => _buildListTile(menu, index),
            ),
          ),
          isLoading ? LoadingScreen(isGray: true) : Container(),
        ],
      ),
    );
  }

  _buildListTile(List<Widget> menu, int index) =>
      index == menu.length ? Container() : menu[index];
}

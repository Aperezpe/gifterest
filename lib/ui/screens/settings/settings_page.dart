import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/resources/app_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/app_drawer.dart';
import 'package:gifterest/ui/common_widgets/custom_app_bar.dart';
import 'package:gifterest/ui/common_widgets/drawer_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/common_widgets/set_form/set_form.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/sign_in/terms_and_conditions.dart';
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

  Future<void> _onSignOut() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    await db.deleteUserToken();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final db = Provider.of<Database>(context, listen: false);

    final menu = <Widget>[
      StreamBuilder<AppUser>(
          stream: db.userStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return ListTile(
                title: Text("Account"),
                onTap: () => _onAsyncMethod(
                  SetPersonForm.create(
                    context,
                    person: user,
                    mainPage: widget,
                    fullscreenDialog: false,
                    fromSettings: true,
                  ),
                  load: false,
                ),
              );
            }
            return LoadingScreen();
          }),
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
        onTap: () => _onAsyncMethod(_onSignOut()),
      ),
      if (AppConfig.of(context).buildFlavor == "Development")
        ListTile(
          title: Text(AppConfig.of(context).buildFlavor),
          onTap: null,
        ),
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

import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/app_user.dart';
import 'package:bonobo/ui/screens/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.databaseBuilder})
      : super(key: key);

  final Database Function(String) databaseBuilder;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            String locatorDisplayName = locator.get<AppUserInfo>().displayName;

            if (user.displayName != locatorDisplayName)
              locator.get<AppUserInfo>().setName(user.displayName);

            final initialUser = AppUser(
              id: user.uid,
              age: null,
              gender: "",
              interests: [],
              // locator provides name because displayName is shaky
              name: user.displayName ?? locatorDisplayName,
              dob: DateTime.now(),
            );

            return Provider<Database>(
              create: (_) => databaseBuilder(user.uid),
              child: MainPage(initialUser: initialUser),
            );
          }

          return SignInPage.create(context);
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class AppUserInfo {
  String displayName;

  String setName(String value) => displayName = value;
}

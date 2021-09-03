import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.databaseBuilder})
      : super(key: key);

  final Database Function(String) databaseBuilder;

  Future<void> _requestNotificationsPermissions() async {
    //Request iOS permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

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
              child: FutureBuilder<void>(
                future: _requestNotificationsPermissions(),
                builder: (context, snapshot) =>
                    MainPage(initialUser: initialUser),
              ),
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

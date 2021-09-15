import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gifterest/flutter_notifications.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

//ignore: must_be_immutable
class LandingPage extends StatelessWidget {
  LandingPage({Key key, @required this.databaseBuilder}) : super(key: key);

  final Database Function(String) databaseBuilder;
  bool isFirstTime = false;

  Future<NotificationSettings> _requestNotificationsPermissions() async {
    //Request iOS permissions
    return await messaging.requestPermission();
  }

  // Creates user if first time user
  // Otherwise, just fetch current user
  Future<AppUser> _createOrFetchUser(
      BuildContext context, AppUser initialUser) async {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    try {
      AppUser user = await database.userStream().first;

      if (user != null) {
        isFirstTime = false;
        return user;
      }

      isFirstTime = true;
      return await database.setPerson(initialUser);
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          if (authSnapshot.hasData) {
            User user = authSnapshot.data;
            print("Current user: ${user.uid}");
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
              child: FutureBuilder<NotificationSettings>(
                future: _requestNotificationsPermissions(),
                builder: (context, notificationsSnapshot) {
                  if (notificationsSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (notificationsSnapshot.hasData) {
                      final authorizationStatus =
                          notificationsSnapshot.data.authorizationStatus;
                      // Used to detect authorization status changes while using application
                      locator
                          .get<NotificationSettingsLocal>()
                          .setAuthorizationStatus(authorizationStatus);

                      print("authorizationStatus: $authorizationStatus");
                      return FutureBuilder<AppUser>(
                        future: _createOrFetchUser(context, initialUser),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return MainPage(
                                initialUser: snapshot.data,
                                authorizationStatus: authorizationStatus,
                                isFirstTime: isFirstTime,
                              );
                            }
                          }
                          return LoadingScreen();
                        },
                      );
                    }
                  }
                  return LoadingScreen();
                },
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

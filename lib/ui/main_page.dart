import 'package:after_layout/after_layout.dart';
import 'package:gifterest/resize/layout_info.dart';
import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/gender.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/my_friends/my_friends_page.dart';
import 'package:gifterest/ui/screens/profile_setup/welcome_page.dart';
// import 'package:device_simulator/device_simulator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const bool debugEnableDeviceSimulator = true;

class MainPage extends StatefulWidget {
  MainPage({Key key, @required this.initialUser}) : super(key: key);
  final Person initialUser;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    // Load genders after it has been built to use throughout the app
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);

    database.genderStream().listen((genders) {
      if (genders.isNotEmpty) {
        print("genders have been loaded");
        locator.get<GenderProvider>().setGenders(genders);
      }
    });

    // If user is not created on sign up for some  reason, this will create it
    database.userStream().listen((user) async {
      print(widget.initialUser);
      if (user == null) await database.setPerson(widget.initialUser);
    }).onError((error) => print("UserStreamError: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gifterest",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito-Sans',
        primaryTextTheme: TextTheme(
          // appbars
          headline6: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.titleSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        textTheme: TextTheme(
          // Text inside columns, and appbar in profile/friend page
          bodyText2: TextStyle(
            color: Colors.black87,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          // Sets AppBarHeight for global use
          locator
              .get<LayoutInfo>()
              .setAppBarHeight(constraints.maxHeight / 12.5);
          return StreamBuilder<Person>(
            stream: database.userStream(),
            builder: (context, snapshot) {
              SizeConfig().init(context);
              // final is700Wide = SizeConfig.screenWidth >= 700;

              if (snapshot.hasData) {
                final user = snapshot.data;

                // if (true)
                //   return DeviceSimulator(
                //     enable: debugEnableDeviceSimulator,
                //     child: _isFirstTime
                //         ? WelcomePage(user: user)
                //         : MyFriendsPage(),
                //   );

                final Auth auth = Provider.of<AuthBase>(context, listen: false);

                bool isFirstTime =
                    auth.userCredentials?.additionalUserInfo?.isNewUser ??
                        false;

                print("isFirstTime? $isFirstTime");
                return isFirstTime ? WelcomePage(user: user) : MyFriendsPage();
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return LoadingScreen();
              }

              return MyFriendsPage();
            },
          );
        },
      ),
    );
  }
}

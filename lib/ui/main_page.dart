import 'package:after_layout/after_layout.dart';
import 'package:bonobo/flutter_notifications.dart';
import 'package:bonobo/resize/layout_info.dart';
import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/profile_setup/welcome_page.dart';
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
  FirebaseNotifications _firebaseNotifications = FirebaseNotifications();

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

  bool _isFirstTime;

  void _saveToken() async {
    await _firebaseNotifications.initialize();
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    String token = await _firebaseNotifications.getToken();

    await database
        .saveUserToken(token)
        .whenComplete(() => print("Tokens have been saved to dabase : $token"));
  }

  @override
  void initState() {
    // Check if user is new to show Setup Profile Page
    final Auth auth = Provider.of<AuthBase>(context, listen: false);

    _isFirstTime = auth.userCredentials?.additionalUserInfo?.isNewUser ?? false;
    print("isFirstTime? $_isFirstTime");

    _saveToken();

    _firebaseNotifications.getInitialMessage();

    super.initState();
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
                return _isFirstTime ? WelcomePage(user: user) : MyFriendsPage();
              }

              return MyFriendsPage();
            },
          );
        },
      ),
    );
  }
}

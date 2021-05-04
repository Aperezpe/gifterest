import 'package:after_layout/after_layout.dart';
import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/screens/profile_setup/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  }

  bool _isFirstTime;

  @override
  void initState() {
    // Check if user is new to show Setup Profile Page
    final Auth auth = Provider.of<AuthBase>(context, listen: false);
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    _isFirstTime = auth.userCredentials?.additionalUserInfo?.isNewUser ?? false;

    print("isFirstTime? $_isFirstTime");

    // If user is not created on sign up for some  reason, this will create it
    database.userStream().listen((user) async {
      if (user == null) await database.setPerson(widget.initialUser);
    }).onError((error) => print("UserStreamError: $error"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bonobo",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<Person>(
        stream: database.userStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return _isFirstTime ? WelcomePage(user: user) : MyFriendsPage();
          }

          return MyFriendsPage();
        },
      ),
    );
  }
}

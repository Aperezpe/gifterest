import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key key});

  static String get routeName => "my-profile";

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  RangeValues sliderValues = RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return FutureBuilder<User>(
      future: auth.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(title: Text(user.displayName)),
            drawer: AppDrawer(currentChildRouteName: MyProfilePage.routeName),
            body: ProfilePage(
              database: database,
              profileImage: user.photoURL == null
                  ? AssetImage(
                      'assets/placeholder.jpg') // get user photoURL if it has one
                  : NetworkImage(user.photoURL),
              title: user.displayName,
              rangeSliderCallBack: (values) =>
                  setState(() => sliderValues = values),
              body: Container(
                child: ProductsGridView(
                  database: database,
                  sliderValues: sliderValues,
                  gender: "Male",
                  productStream: database.queryUserProductsStream(
                    age: 21,
                    gender: "Male",
                    interests: [
                      "Anime",
                      "Biking",
                      "Sports",
                      "Traveling",
                      "Movie Night",
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: Text("Generating recommendations..."));
      },
    );
  }
}

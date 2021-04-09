import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
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

  // Just to use right now because I should have the person saved in database
  // already
  Person userToPerson(User user) {
    // TODO: I can even create a locator when signing in to get user from
    // firebase
    return Person(
      age: 26,
      gender: "Male",
      id: user.uid,
      imageUrl: user.photoURL ??
          "https://firebasestorage.googleapis.com/v0/b/important-dates-reminders.appspot.com/o/placeholder.jpg?alt=media&token=992705e8-7b42-4ae4-9836-0d3d00bad376",
      interests: ["Biking", "Cars", "Music", "Outdoors", "Sports"],
      name: user.displayName ?? "Abraham",
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return FutureBuilder<User>(
      future: auth.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.displayName),
              actions: [
                TextButton(
                  child: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => SetPersonForm.create(
                    context,
                    person: userToPerson(user),
                    mainPage: widget,
                    firebaseStorage: FirebaseUserStorage(uid: database.uid),
                  ),
                ),
              ],
            ),
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

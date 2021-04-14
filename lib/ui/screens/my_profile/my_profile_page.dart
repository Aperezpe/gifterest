import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);
    return StreamBuilder<Person>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return Scaffold(
            appBar: CustomAppBar(
              title: Text('${user.name} (Me)'),
              actions: [
                user.interests.isNotEmpty
                    ? TextButton(
                        child: Icon(Icons.edit, color: Colors.white),
                        onPressed: () => SetPersonForm.create(
                          context,
                          person: user,
                          mainPage: widget,
                          firebaseStorage:
                              FirebaseUserStorage(uid: database.uid),
                        ),
                      )
                    : Container(),
              ],
            ),
            drawer: AppDrawer(currentChildRouteName: MyProfilePage.routeName),
            body: user.interests.isNotEmpty
                ? ProfilePage(
                    database: database,
                    profileImage: user.imageUrl == null
                        ? AssetImage(
                            'assets/placeholder.jpg') // TODO: get user photoURL if it has one
                        : NetworkImage(user.imageUrl),
                    title: user.name,
                    rangeSliderCallBack: (values) =>
                        setState(() => sliderValues = values),
                    body: Container(
                      child: ProductsGridView(
                        database: database,
                        sliderValues: sliderValues,
                        gender: user.gender,
                        productStream: database.queryUserProductsStream(
                          age: user.age,
                          gender: user.gender,
                          interests: user.interests,
                        ),
                      ),
                    ),
                  )
                : Material(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile not setup yet",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text("Setup to see your recommendations!"),
                          SizedBox(height: 20),
                          CustomButton(
                            text: "Setup Profile!",
                            onPressed: () =>
                                Navigator.of(context).push(PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: SetupPage(user: user),
                            )),
                            color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        }
        return Material(
          child: Center(
            child: Text("Generating recommendations..."),
          ),
        );
      },
    );
  }
}

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/app_drawer.dart';
import 'package:gifterest/ui/common_widgets/custom_app_bar.dart';
import 'package:gifterest/ui/common_widgets/custom_button.dart';
import 'package:gifterest/ui/common_widgets/drawer_button_builder.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/common_widgets/profile_page/profile_page.dart';
import 'package:gifterest/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:gifterest/ui/common_widgets/set_form/set_form.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/profile_setup/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
    SizeConfig().init(context);

    final is700Wide = SizeConfig.screenWidth >= 700;
    return StreamBuilder<AppUser>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return Scaffold(
            drawer: AppDrawer(currentChildRouteName: MyProfilePage.routeName),
            body: user.interests.isNotEmpty
                ? ProfilePage(
                    dismissableAppBar: CustomAppBar(
                      isDismissable: true,
                      title: user.name,
                      leading: DrawerButtonBuilder(),
                      actions: [
                        user.interests.isNotEmpty
                            ? TextButton(
                                child: Icon(
                                  LineIcons.userEdit,
                                  color: Colors.white,
                                  size: is700Wide
                                      ? SizeConfig.safeBlockVertical * 3.2
                                      : SizeConfig.safeBlockVertical * 3.8,
                                ),
                                onPressed: () => SetPersonForm.create(
                                  context,
                                  person: user,
                                  mainPage: widget,
                                ),
                              )
                            : Container(),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 100.0),
                        ),
                      ),
                    ),
                    database: database,
                    title: user.name,
                    rangeSliderCallBack: (values) =>
                        setState(() => sliderValues = values),
                    body: Container(
                      child: ProductsGridView(
                        person: user,
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
        return LoadingScreen();
      },
    );
  }
}

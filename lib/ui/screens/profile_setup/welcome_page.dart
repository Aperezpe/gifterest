import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/common_widgets/gradient_button.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/profile_setup/setup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key, @required this.user}) : super(key: key);

  final Person user;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final is800Hight = SizeConfig.screenHeight >= 800;
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[400], Colors.white],
            stops: [0, .5],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 8,
                    right: SizeConfig.safeBlockHorizontal * 8,
                  ),
                  child: Text(
                    "Awesome ${user.name}!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.h1Size * 1.2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset(
                  'assets/congrats.png',
                  width: SizeConfig.screenWidth / 2,
                ),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 8,
                    right: SizeConfig.safeBlockHorizontal * 8,
                  ),
                  child: Text(
                    "You have successfully created your account!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: SizeConfig.subtitleSize * 1.2,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 5,
                  right: SizeConfig.blockSizeHorizontal * 5,
                  top: is800Hight
                      ? SizeConfig.safeBlockVertical * 3
                      : SizeConfig.blockSizeVertical * 2.2,
                  bottom: is800Hight
                      ? SizeConfig.safeBlockVertical * 2.5
                      : SizeConfig.blockSizeVertical * 1.2,
                ),
                child: GradientButton(
                  text: "Continue",
                  textSize: SizeConfig.h4Size,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SetupPage(user: user)),
                  ),
                  textColor: Colors.white,
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xff38BDFF), Color(0xffBA6BFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shadowColor: Color(0xff001AFF).withOpacity(.38),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/common_widgets/gradient_button.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/profile_setup/gender_page.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key key, @required this.user}) : super(key: key);
  final Person user;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final is800Hight = SizeConfig.screenHeight >= 800;
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Color(0xffFB997F), Color(0xffF47199)],
              radius: 1.3,
              center: Alignment(0, -.4)),
        ),
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 5,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset('assets/carita.png'),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Text(
                "Setup your profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: SizeConfig.titleSize * 1.2,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        offset: Offset(1, 4),
                        blurRadius: 4,
                      ),
                    ]),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 8,
                  right: SizeConfig.safeBlockHorizontal * 8,
                ),
                child: Text(
                  "Allow us to ask you 3 questions and we'll give you better recommendations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.subtitleSize * 1.2,
                    fontFamily: 'Mulish',
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
                  text: "Let's Start",
                  textSize: SizeConfig.h4Size,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GenderPage(user: user),
                    ),
                  ),
                  textColor: Colors.white,
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xff00E9D0), Color(0xff00AD87)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shadowColor: Colors.black.withOpacity(.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/gender.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/profile_setup/age_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderPage extends StatelessWidget {
  GenderPage({Key key, @required this.user}) : super(key: key);

  final Person user;

  void _onPressed(BuildContext context, String genderType) async {
    user.gender = genderType;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgePage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<List<Gender>>(
      stream: Provider.of<Database>(context, listen: false).genderStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final genders = snapshot.data.map((gender) => gender.type).toList();
          return Material(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff599BF9),
                    Color(0xffBF4EF9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: SizeConfig.safeBlockVertical * 8),
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 8,
                      right: SizeConfig.safeBlockHorizontal * 8,
                    ),
                    child: Text(
                      "What is your gender?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 5,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            offset: Offset(1, 4),
                            color: Colors.black.withOpacity(.25),
                            blurRadius: 4,
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 2),
                  for (String gender in genders)
                    GenderButton(
                      onPressed: () => _onPressed(context, gender),
                      text: gender,
                    ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          );
        }
        return LoadingScreen();
      },
    );
  }
}

class GenderButton extends StatelessWidget {
  const GenderButton({
    Key key,
    @required this.onPressed,
    this.text,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Container(
      height: is700Wide
          ? SizeConfig.safeBlockVertical * 12
          : SizeConfig.safeBlockVertical * 14,
      padding: EdgeInsets.fromLTRB(
        SizeConfig.safeBlockHorizontal * 5,
        SizeConfig.safeBlockVertical * 2,
        SizeConfig.safeBlockHorizontal * 5,
        SizeConfig.safeBlockVertical,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: is700Wide
                      ? SizeConfig.safeBlockVertical * 2.5
                      : SizeConfig.safeBlockVertical * 3,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: SizeConfig.safeBlockVertical * 4.5,
              )
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black.withOpacity(.38),
          alignment: Alignment.centerLeft,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(width: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

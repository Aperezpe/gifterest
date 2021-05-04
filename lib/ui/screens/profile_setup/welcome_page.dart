import 'package:bonobo/ui/common_widgets/gradient_button.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/setup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key, @required this.user}) : super(key: key);

  final Person user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[400], Colors.white],
              stops: [0, .5],
            ),
          ),
          padding: EdgeInsets.fromLTRB(20, 80, 20, 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Awesome ${user.name}!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/congrats.png',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "You have successfully created your account!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
              GradientButton(
                text: "Continue",
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
            ],
          ),
        ),
      ),
    );
  }
}

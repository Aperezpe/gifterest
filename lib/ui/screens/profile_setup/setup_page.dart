import 'package:bonobo/ui/common_widgets/gradient_button.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/gender_page.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key key, @required this.user}) : super(key: key);
  final Person user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Color(0xffFB997F), Color(0xffF47199)],
                radius: 1.3,
                center: Alignment(0, -.4)),
          ),
          padding: EdgeInsets.fromLTRB(20, 150, 20, 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset('assets/carita.png'),
                  ),
                  SizedBox(height: 80),
                  Text(
                    "Setup your profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36,
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
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Allow us to ask you 3 questions and we'll give you better recommendations",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
              GradientButton(
                text: "Let's Start",
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
            ],
          ),
        ),
      ),
    );
  }
}

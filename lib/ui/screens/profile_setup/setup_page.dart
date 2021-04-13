import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/gender_page.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key key, @required this.user}) : super(key: key);
  final Person user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 150, 20, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Text(
                  "Setup your profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Allow us to ask you 3 questions to setup your profile and give you better recommendations",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                ),
                Container(
                  child: Image.asset('assets/monkey.png'),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
                ),
              ],
            ),
            CustomButton(
              text: "Let's start",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GenderPage(user: user)),
              ),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

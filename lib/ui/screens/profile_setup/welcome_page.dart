import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/setup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key, @required this.user}) : super(key: key);

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
                  "Awesome ${user.name}!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Image.asset(
                  'assets/thumb.jpg',
                  width: 200,
                ),
                SizedBox(height: 50),
                Text(
                  "You have successfully created your account!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                ),
              ],
            ),
            CustomButton(
              text: "Continue",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SetupPage(user: user)),
              ),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

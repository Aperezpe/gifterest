import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/age_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final Map<String, dynamic> genderData = {
    "Male": {
      "color": Colors.blue,
      "icon": FontAwesomeIcons.mars,
    },
    "Female": {
      "color": Colors.pink,
      "icon": FontAwesomeIcons.venus,
    },
    "Other": {
      "color": Colors.black54,
      "icon": FontAwesomeIcons.genderless,
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border(bottom: BorderSide.none),
      ),
      body: StreamBuilder<List<Gender>>(
        stream: Provider.of<Database>(context, listen: false).genderStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final genders = snapshot.data.map((gender) => gender.type).toList();
            return Container(
              padding: EdgeInsets.fromLTRB(20, 25, 20, 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "What is your gender?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  for (String gender in genders)
                    Expanded(
                      child: GenderButton(
                        onPressed: () => _onPressed(context, gender),
                        icon: genderData[gender]["icon"],
                        iconColor: genderData[gender]["color"],
                        text: gender,
                        textColor: genderData[gender]["color"],
                      ),
                    ),
                ],
              ),
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  const GenderButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
    this.iconColor,
    this.textColor: Colors.blue,
    this.text,
  }) : super(key: key);

  final onPressed;
  final text;
  final textColor;
  final iconColor;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: iconColor,
              size: 85,
            ),
            Text(text, style: TextStyle(color: textColor, fontSize: 20)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }
}

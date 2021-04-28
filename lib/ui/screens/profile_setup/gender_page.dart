import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/profile_setup/age_page.dart';
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
                  Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 38,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      "What is your gender?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
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
                  SizedBox(height: 20),
                  for (String gender in genders)
                    Flexible(
                      child: GenderButton(
                        onPressed: () => _onPressed(context, gender),
                        text: gender,
                      ),
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
    return Container(
      height: 90,
      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(Icons.chevron_right, size: 36)
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black.withOpacity(.38),
          alignment: Alignment.centerLeft,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(width: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

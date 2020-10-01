import 'package:flutter/material.dart';
import '../../../resize/size_config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.safeBlockVertical * 12,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeVertical * 3,
              ),
              child: Image.asset(
                "assets/bonobo_logo.png",
                height: SizeConfig.safeBlockVertical * 14,
                width: SizeConfig.safeBlockVertical * 14,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
            child: Text(
              "BONOBO",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockVertical * 4,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(35, 20, 35, 20),
            child: Text(
              "Event reminders and customized gift suggestions to strengthen your most precious relationships.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                fontWeight: FontWeight.w300,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.blockSizeHorizontal * 10,
              20,
              SizeConfig.blockSizeHorizontal * 10,
              40,
            ),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Provide a name";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    hintText: "Email",
                    filled: true,
                    fillColor: Color(0xffEAEAEA),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 14.0),
                      child: Icon(Icons.email),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.safeBlockVertical * 12,
                      ),
                      borderSide: BorderSide(color: Color(0xffEAEAEA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.safeBlockVertical * 12,
                      ),
                      borderSide: BorderSide(color: Color(0xffFF3969)),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

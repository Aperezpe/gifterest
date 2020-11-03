import 'package:bonobo/services/auth.dart';
import 'package:flutter/material.dart';
import '../../../resize/size_config.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          FlatButton(
            child: Text("Sign Out"),
            onPressed: auth.signOut,
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: SizeConfig.blockSizeVertical * 20,
          width: SizeConfig.blockSizeHorizontal * 50,
          child: Text(
            "Welcome!",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

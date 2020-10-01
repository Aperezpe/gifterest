import 'package:flutter/material.dart';
import '../../../resize/size_config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Container(
          height: SizeConfig.blockSizeVertical * 20,
          width: SizeConfig.blockSizeHorizontal * 50,
          color: Colors.orange,
        ),
      ),
    );
  }
}

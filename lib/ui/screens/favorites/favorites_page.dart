import 'package:bonobo/ui/app_drawer.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: Container(
        child: Center(
          child: Text("Favorites"),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

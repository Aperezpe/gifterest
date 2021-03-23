import 'package:bonobo/services/auth.dart';
import 'package:bonobo/ui/style/fontStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          FlatButton(
            onPressed: auth.signOut,
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Las condiciones para cambiar el header varian:
            /// 1.- El usuario acaba de registrarse -> NewHeader
            /// 2.- El usuario lleva mas de una semana -> NormalHeader
            /// 3.- There's a monthly event -> Si se acaba de registrar, enseñar el header de como usar
            /// la app solo un dia y al siguiente enseñar el evento

            FutureBuilder<User>(
              future: auth.currentUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final creationTime = snapshot.data.metadata.creationTime;
                  final now = DateTime.now();
                  final isNewUser =
                      now.difference(creationTime) <= Duration(days: 7);

                  return isNewUser
                      ? _buildNewUserHeader(snapshot.data)
                      : _buildOldUserHeader(snapshot.data);
                } else if (snapshot.hasError) {
                  return Container(child: Text("Error"));
                }
                return Container(height: 150, color: Colors.grey[100]);
              },
            ),
            _buildUpcomingEvents(),
            _buildRecommendationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Recommendations for you",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(color: Colors.green),
                Container(
                  padding: EdgeInsets.only(left: 25, bottom: 15),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("See All"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    List<Color> colors = [Colors.red, Colors.blue];
    return Container(
      height: 200,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Upcoming Events",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (context, index) => Container(
                color: colors[index % 2],
                height: 50,
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewUserHeader(User user) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 150,
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Hello ${user.displayName}!",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Container(
            child: Text("This is a NEW user heaader"),
          ),
        ],
      ),
    );
  }

  Widget _buildOldUserHeader(User user) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 80,
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Hello back ${user.displayName}!",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Container(
            child: Text("This is an OLD user heaader"),
          ),
        ],
      ),
    );
  }
}

import 'package:bonobo/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/interest.dart';

class InterestsPage extends StatefulWidget {
  InterestsPage({@required this.database});
  final FirestoreDatabase database;

  static Future<void> show(BuildContext context,
      {FirestoreDatabase database}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InterestsPage(database: database),
      ),
    );
  }

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];
  Stream<List<Interest>> get interestStream => widget.database.interestStream();

  void _tapInterest(String interest) {
    final bool isSelected = selectedInterests.contains(interest);
    setState(() {
      if (isSelected) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interests"),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<Interest>>(
      stream: interestStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final interests = snapshot.data;
          final children =
              interests.map((interest) => _buildInterest(interest)).toList();

          return GridView.count(
            crossAxisCount: 2,
            children: children,
            padding: EdgeInsets.all(15),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Some error occured"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildInterest(Interest interest) {
    final bool isSelected = selectedInterests.contains(interest.nameId);

    return Card(
      color: isSelected ? Colors.pink : Colors.white,
      elevation: 8.0,
      child: InkWell(
        onTap: () => _tapInterest(interest.nameId),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/naruto.png'),
            Text(
              interest.nameId,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

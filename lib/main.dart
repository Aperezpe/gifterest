import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/landing/landing_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: LandingPage(
        databaseBuilder: (uid) => FirestoreDatabase(uid: uid),
      ),
    );
  }
}

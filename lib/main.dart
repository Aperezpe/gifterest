import 'dart:io';

import 'package:gifterest/services/apple_sign_in_available.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ui/screens/landing/landing_page.dart';

void main() async {
  // HttpOverrides.global = new MyHttpOverrides(); // Only use in DEV
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  final appleSignInAvailable = await AppleSignInAvailable.check();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: MyApp(),
    )),
  );
}

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

///This should be used while in development mode, do NOT do this when you want to release to production,
///the aim of this answer is to make the development a bit easier for you, for production, you need to
///fix your certificate issue and use it properly, look at the other answers for this as it might be helpful for your case.
///https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

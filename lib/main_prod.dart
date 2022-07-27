import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifterest/services/apple_sign_in_available.dart';
import 'package:gifterest/services/locator.dart';
import 'package:provider/provider.dart';
import 'resources/app_config.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  final appleSignInAvailable = await AppleSignInAvailable.check();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Still not sure if this is correct
  var configuredApp = AppConfig(
    child: Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: MyApp(),
    ),
    appTitle: 'Gifterest',
    buildFlavor: 'Release Version',
  );

  return runApp(configuredApp);
}

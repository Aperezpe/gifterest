import 'dart:async';

import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/main_page.dart';
import 'package:gifterest/ui/screens/landing/landing_page.dart';
import 'package:gifterest/ui/screens/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuth extends Mock implements Auth {}

class MockDatabase extends Mock implements Database {}

class MockUser extends Mock implements User {
  MockUser();
  factory MockUser.uid(String uid) {
    final user = MockUser();
    when(user.uid).thenReturn(uid);
    return user;
  }
}

void main() {
  MockAuth mockAuth;
  MockDatabase mockDatabase;
  StreamController<User> onAuthStateChangeController;

  setUp(() {
    mockAuth = MockAuth();
    mockDatabase = MockDatabase();
    onAuthStateChangeController = StreamController<User>();
  });

  tearDown(() {
    onAuthStateChangeController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (context) => mockAuth,
        child: MaterialApp(
          home: LandingPage(
            databaseBuilder: (_) => mockDatabase,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
    onAuthStateChangeController.addStream(
      Stream<User>.fromIterable(onAuthStateChanged),
    );
    when(mockAuth.onAuthStateChanged).thenAnswer((_) {
      return onAuthStateChangeController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubOnAuthStateChangedYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(LoadingScreen), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {
    stubOnAuthStateChangedYields([null]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async {
    stubOnAuthStateChangedYields([MockUser.uid('123')]);

    await pumpLandingPage(tester);

    // TODO: Change this to HomeScreen once I have the home screen
    expect(find.byType(MainPage), findsOneWidget);
  });
}

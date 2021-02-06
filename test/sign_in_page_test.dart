import 'package:bonobo/services/auth.dart';
import 'package:bonobo/ui/screens/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (context) => mockAuth,
        child: MaterialApp(
          home: StreamBuilder(
            builder: (context, snapshot) {
              return SignInPage.create(context);
            },
          ),
        ),
      ),
    );
  }

  group('Sign In: ', () {
    testWidgets(
        'WHEN user doesn\'t enter the email and password '
        'AND user taps on the sign-in button '
        'THEN signInWithEmailAndPassword is not called',
        (WidgetTester tester) async {
      await pumpSignInPage(tester);

      final signInButton = find.byKey(Key("sign-in/up-btn"));
      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    });
    testWidgets(
        'WHEN user enters the email and password '
        'AND user taps on the sign-in button '
        'THEN signInWithEmailAndPassword is called',
        (WidgetTester tester) async {
      await pumpSignInPage(tester);

      const email = "ab@ab.com";
      const password = "password";

      final emailField = find.byKey(Key("email"));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key("password"));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.byKey(Key("sign-in/up-btn"));
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    });
  });

  group('Sign Up: ', () {
    testWidgets(
        'WHEN user doesn\'t enter anything '
        'AND user taps on the sign-up button '
        'THEN createUserWithEmailAndPassword is not called',
        (WidgetTester tester) async {
      await pumpSignInPage(tester);
      final switchFormButton = find.text("Need an account? Sign Up");
      await tester.tap(switchFormButton);

      await tester.pump();
      final signUpButton = find.text("Create an account");
      expect(signUpButton, findsOneWidget);

      final singUpButton = find.byKey(Key("sign-in/up-btn"));
      await tester.tap(singUpButton);

      verifyNever(mockAuth.createUserWithEmailAndPassword(any, any, any));
    });

    testWidgets(
        'WHEN user misses a field '
        'AND user taps on the sign-in button '
        'THEN createUserWithEmailAndPassword is not called',
        (WidgetTester tester) async {
      await pumpSignInPage(tester);
      final switchFormButton = find.text("Need an account? Sign Up");
      await tester.tap(switchFormButton);

      await tester.pump();
      final signUpButton = find.text("Create an account");
      expect(signUpButton, findsOneWidget);

      const name = "Ab";
      const email = "ab@ab.com";
      const password = "password";
      const retypePassword = "";

      final namefield = find.byKey(Key("name"));
      expect(namefield, findsOneWidget);
      await tester.enterText(namefield, name);

      final emailField = find.byKey(Key("email"));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key("password"));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      final retypePasswordField = find.byKey(Key("retype-password"));
      expect(retypePasswordField, findsOneWidget);
      await tester.enterText(retypePasswordField, retypePassword);

      await tester.pump();

      final signInButton = find.text("Create an account");
      await tester.tap(signInButton);

      verify(
        mockAuth.createUserWithEmailAndPassword(name, email, password),
      ).called(1);
    });
  });
}

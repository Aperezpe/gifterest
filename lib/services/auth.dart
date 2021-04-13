import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/screens/landing/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(
      String name, String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  UserCredential _userCredentials;

  UserCredential get userCredentials => _userCredentials;

  User _userFromFirebase(User user) {
    if (user == null) return null;

    return user;
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    final authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => _userCredentials = value);

    await _firebaseAuth.currentUser.updateProfile(displayName: name);
    await authResult.user.updateProfile(displayName: name);

    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(scopes: []);
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      try {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResult = await _firebaseAuth
              .signInWithCredential(
                GoogleAuthProvider.credential(
                    idToken: googleAuth.idToken,
                    accessToken: googleAuth.accessToken),
              )
              .then((value) => _userCredentials = value);

          locator.get<AppUserInfo>().setName(authResult.user.displayName);

          return _userFromFirebase(authResult.user);
        } else {
          throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token',
          );
        }
      } catch (e) {
        // If normal sign in doesn't work, try silently
        try {
          print("Warning: Trying to sign in silently!");
          final googleAccount = await googleSignIn.signInSilently();
          if (googleAccount != null) {
            try {
              final googleAuth = await googleAccount.authentication;
              if (googleAuth.accessToken != null &&
                  googleAuth.idToken != null) {
                final authResult = await _firebaseAuth
                    .signInWithCredential(GoogleAuthProvider.credential(
                      idToken: googleAuth.idToken,
                      accessToken: googleAuth.accessToken,
                    ))
                    .then((value) => _userCredentials = value);
                locator.get<AppUserInfo>().setName(authResult.user.displayName);

                return _userFromFirebase(authResult.user);
              }
            } catch (e) {
              rethrow;
            }
          }
        } catch (e) {
          rethrow;
        }
        rethrow;
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

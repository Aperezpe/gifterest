import 'package:gifterest/services/api_path.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/firestore_service.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:gifterest/ui/screens/landing/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gifterest/flutter_notifications.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  UserCredential get userCredentials;
  Future<User> currentUser();
  Future<void> deleteUserAccount(String password, Database database);
  String getAuthProviderId();
  Future<bool> isReauthenticationSuccessful(String password);
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
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

    await _firebaseAuth.currentUser.updateDisplayName(name);
    await authResult.user.updateDisplayName(name);

    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  Future<GoogleSignInAuthentication>
      _generateGoogleSignInAuthentication() async {
    final googleSignIn = GoogleSignIn(scopes: []);
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      return googleAccount.authentication;
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleAuth = await _generateGoogleSignInAuthentication();
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
      final googleSignIn = GoogleSignIn(scopes: []);
      try {
        print("Warning: Trying to sign in silently!");
        final googleAccount = await googleSignIn.signInSilently();
        if (googleAccount != null) {
          try {
            final googleAuth = await googleAccount.authentication;
            if (googleAuth.accessToken != null && googleAuth.idToken != null) {
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
  }

  Future<AppleIdCredential> __generateAppleCredentials(
      List<Scope> scopes) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    // 2. check results
    switch (result.status) {
      case AuthorizationStatus.authorized:
        return result.credential;
        break;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    try {
      final appleIdCredential = await __generateAppleCredentials(scopes);
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken),
        accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (scopes.contains(Scope.fullName)) {
        final fullName = appleIdCredential.fullName;
        final email = appleIdCredential.email;
        if (fullName != null &&
            fullName.givenName != null &&
            fullName.familyName != null) {
          final displayName = '${fullName.givenName} ${fullName.familyName}';
          await firebaseUser.updateDisplayName(displayName);
          await firebaseUser.updateEmail(email);
        } else {
          await firebaseUser.updateDisplayName("user");
        }
      } else {
        await firebaseUser.updateDisplayName("user");
      }

      return firebaseUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final _firebaseNotifications = FirebaseNotifications();

    await _firebaseNotifications.deleteToken();

    print("deleting token...");
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<void> _deleteUserAccountFromDB(String uid, Database database) async {
    final _service = FirestoreService.instance;

    print("User about to be deleted from DB: $uid");

    // Delete Root Special Events first since user/special_events is needed as parameter
    await for (final specialEvents in database.specialEventsStream()) {
      for (final event in specialEvents) {
        print("Deleting event: ${event.name} of ${event.personId}");
        await _service.deleteDocument(path: APIPath.rootSpecialEvent(event.id));
      }
      break;
    }

    print("Deleting user account from DB");
    await _service.deleteDocument(path: APIPath.user(uid));
  }

  @override
  Future<void> deleteUserAccount(String password, Database database) async {
    final _firebaseNotifications = FirebaseNotifications();

    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        await _deleteUserAccountFromDB(user.uid, database);
        print("Deleting Firebase Notifications Token");
        await _firebaseNotifications.deleteToken();
        print("Deleting user account from firebase");
        await user.delete();
      }
    } catch (e) {
      throw PlatformException(
        code: 'ERROR_WRONG_PASSWORD',
        message: "It looks like the password is invalid",
      );
    }
  }

  @override
  String getAuthProviderId() {
    final user = _firebaseAuth.currentUser;
    final providerId = user.providerData.first.providerId;

    return providerId;
  }

  @override
  Future<bool> isReauthenticationSuccessful(String password) async {
    try {
      final user = _firebaseAuth.currentUser;
      final providerId = getAuthProviderId();

      AuthCredential credential;

      if (providerId == 'google.com') {
        final googleAuth = await _generateGoogleSignInAuthentication();
        credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      } else if (providerId == 'apple.com') {
        final appleIdCredential = await __generateAppleCredentials([]);
        final oAuthProvider = OAuthProvider(providerId);
        credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
      } else if (providerId == 'password') {
        credential =
            EmailAuthProvider.credential(email: user.email, password: password);
      }

      UserCredential result =
          await user.reauthenticateWithCredential(credential);

      if (result != null) {
        print("Reauthenticated successfully!!: $result");
        print("Credentials of user: $user");
        return true;
      }
      return null;
    } catch (e) {
      throw PlatformException(
        code: 'ERROR_WRONG_PASSWORD',
        message: "It looks like the password is invalid",
      );
    }
  }
}

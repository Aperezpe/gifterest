import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/locator.dart';
import 'package:bonobo/ui/screens/landing/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../validators.dart';

enum EmailSignInFormType { signIn, signUp }

class SignInModel with EmailAndPasswordValidators, ChangeNotifier {
  SignInModel({
    @required this.auth,
    this.name = '',
    this.email = '',
    this.password = '',
    this.retypePassword = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = true,
    this.submitted = false,
  });

  final AuthBase auth;
  String name;
  String password;
  String retypePassword;
  String email;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true);
    if (!canSubmit) return;
    if (formType == EmailSignInFormType.signIn) {
      await _signIn(
        () => auth.signInWithEmailAndPassword(
          email,
          password,
        ),
      );
    } else {
      locator.get<AppUserInfo>().setName(name);
      await _signIn(
        () => auth.createUserWithEmailAndPassword(
          name,
          email,
          password,
        ),
      );
    }
  }

  String get primaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Sign Up'
        : 'Have an account? Sign In';
  }

  String get socialMediaText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In with:'
        : 'Sing Up with:';
  }

  bool get canSubmit {
    if (formType == EmailSignInFormType.signIn) {
      return emailValidator.isValid(email) &&
          passwordValidator.isValid(password) &&
          !isLoading;
    }

    return nameValidator.isValid(name) &&
        emailValidator.isValid(email) &&
        retypePasswordValidator.isValid(password, retypePassword) &&
        !isLoading;
  }

  String get nameErrorText {
    bool showErrorText = submitted && !nameValidator.isValid(name);
    return showErrorText ? invalidNameErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get retypePasswordErrorText {
    bool showErrorText =
        submitted && !retypePasswordValidator.isValid(password, retypePassword);
    return showErrorText ? invalidRetypePasswordErrorText : null;
  }

  void toogleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.signUp
        : EmailSignInFormType.signIn;
    updateWith(
      name: '',
      email: '',
      password: '',
      retypePassword: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateName(String name) => updateWith(name: name);
  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateRetypePassword(String retypePassword) =>
      updateWith(retypePassword: retypePassword);

  void updateWith({
    String name,
    String email,
    String password,
    String retypePassword,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.retypePassword = retypePassword ?? this.retypePassword;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      updateWith(isLoading: true);
      return await signInMethod();
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}

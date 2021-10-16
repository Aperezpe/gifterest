import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/screens/landing/landing_page.dart';
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
    this.hasAcceptedTerms = false,
    this.hasReadTerms = false,
  });

  final AuthBase auth;
  String name;
  String password;
  String retypePassword;
  String email;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  bool hasAcceptedTerms;
  bool hasReadTerms;

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
        hasAcceptedTerms &&
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

  /// The user has to read the terms first before being able to check the
  /// Terms & Conditions checkbox.
  void updateHasAcceptedTerms(bool value) =>
      updateWith(hasAcceptedTerms: value);
  void updateHasReadTerms(bool value) => updateWith(hasReadTerms: value);

  void updateWith({
    String name,
    String email,
    String password,
    String retypePassword,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
    bool hasAcceptedTerms,
    bool hasReadTerms,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.retypePassword = retypePassword ?? this.retypePassword;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.hasAcceptedTerms = hasAcceptedTerms ?? this.hasAcceptedTerms;
    this.hasReadTerms = hasReadTerms ?? this.hasReadTerms;
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

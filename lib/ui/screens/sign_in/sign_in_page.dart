import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:bonobo/ui/screens/sign_in/models/sign_in_model.dart';
import 'package:bonobo/ui/screens/sign_in/widgets/sign_in_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

import '../../common_widgets/circle_image_button.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';

import 'package:bonobo/services/auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage({@required this.model});

  final SignInModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(auth: auth),
      child: Consumer<SignInModel>(
        builder: (_, model, __) => SignInPage(model: model),
      ),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _retypePasswordController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _reTypePasswordFocusNode = FocusNode();

  SignInModel get model => widget.model;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      FirebaseAuthExceptionAlertDialog(
        title: "Sign in failed",
        exception: e,
      ).show(context);
    }
  }

  void _showSignInError(PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle() async {
    try {
      await model.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(e);
      } else {
        _showSignInError(e);
      }
    }
  }

  void _toogleFormType() {
    model.toogleFormType();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _retypePasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bonobo",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(body: _buildContent()),
    );
  }

  Widget _buildContent() {
    return OverflowBox(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(),
            SizedBox(height: 15),
            _buildEmailForm(),
            SizedBox(height: 15),
            _buildSignInServices(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (model.isLoading) {
      return Center(
        heightFactor: 8,
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(top: 35),
          height: 150,
          child: Image.asset("assets/bonobo_logo.png"),
        ),
        Container(
          alignment: Alignment.center,
          height: 80,
          child: Text(
            "BONOBO",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ],
    );
  }

  Column _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        model.formType == EmailSignInFormType.signIn
            ? Column(
                children: <Widget>[
                  SignInTextField(
                    focusNode: _emailFocusNode,
                    key: Key("email"),
                    controller: _emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    errorText: model.emailErrorText,
                    onChanged: model.updateEmail,
                    enabled: model.isLoading == false,
                  ),
                  SizedBox(height: 15),
                  SignInTextField(
                    focusNode: _passwordFocusNode,
                    key: Key("password"),
                    controller: _passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _submit,
                    obscureText: true,
                    onChanged: model.updatePassword,
                    errorText: model.passwordErrorText,
                    enabled: model.isLoading == false,
                  ),
                ],
              )
            : Column(
                children: [
                  SignInTextField(
                    key: Key("name"),
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    hintText: "Name",
                    icon: Icons.person,
                    textInputAction: TextInputAction.next,
                    errorText: model.nameErrorText,
                    onChanged: model.updateName,
                    enabled: model.isLoading == false,
                  ),
                  SizedBox(height: 15),
                  SignInTextField(
                    key: Key("email"),
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    errorText: model.emailErrorText,
                    onChanged: model.updateEmail,
                    enabled: model.isLoading == false,
                  ),
                  SizedBox(height: 15),
                  SignInTextField(
                    key: Key("password"),
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    onChanged: model.updatePassword,
                    errorText: model.passwordErrorText,
                    enabled: model.isLoading == false,
                  ),
                  SizedBox(height: 15),
                  SignInTextField(
                    key: Key("retype-password"),
                    focusNode: _reTypePasswordFocusNode,
                    controller: _retypePasswordController,
                    hintText: "Retype Password",
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _submit,
                    obscureText: true,
                    onChanged: model.updateRetypePassword,
                    errorText: model.retypePasswordErrorText,
                    enabled: model.isLoading == false,
                  ),
                ],
              ),
        SizedBox(height: 30),
        CustomButton(
          key: Key("sign-in/up-btn"),
          text: model.primaryText,
          color: Colors.pink[400],
          textColor: Colors.white,
          onPressed: model.isLoading ? null : _submit,
        ),
        SizedBox(height: 15),
        TextButton(
          key: Key("toggle-form"),
          child: Text(
            model.secondaryText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(primary: Colors.white),
          onPressed: model.isLoading ? null : _toogleFormType,
        ),
      ],
    );
  }

  Column _buildSignInServices() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            model.socialMediaText,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleImageButton(
              key: Key("google-signin"),
              color: Colors.white,
              textColor: Colors.blue,
              onPressed: model.isLoading ? null : _signInWithGoogle,
              imagePath: 'assets/google_logo.jpg',
            ),
            CircleImageButton(
              key: Key("apple-signin"),
              color: Colors.grey[400],
              textColor: Colors.white,
              onPressed: null,
              imagePath: 'assets/apple_logo.jpg',
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

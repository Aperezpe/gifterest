import 'dart:async';

import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/apple_sign_in_available.dart';
import 'package:gifterest/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:gifterest/ui/common_widgets/custom_button.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/screens/sign_in/models/sign_in_model.dart';
import 'package:gifterest/ui/screens/sign_in/terms_and_conditions.dart';
import 'package:gifterest/ui/screens/sign_in/widgets/sign_in_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/circle_image_button.dart';

import 'package:gifterest/services/auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage({@required this.model});

  final SignInModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gifterest",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        accentColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: ChangeNotifierProvider<SignInModel>(
        create: (_) => SignInModel(auth: auth),
        child: Consumer<SignInModel>(
          builder: (_, model, __) => SignInPage(model: model),
        ),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => model.updateWith(isLoading: false));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  Stream<bool> termsState(bool value) async* {
    yield value;
  }

  Future<void> _submit() async {
    try {
      await model.submit();
    } on PlatformException catch (e) {
      PlatformExceptionCustomDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      FirebaseAuthExceptionCustomDialog(
        title: "Sign in failed",
        exception: e,
      ).show(context);
    } on FirebaseException catch (e) {
      FirebaseAuthExceptionCustomDialog(
        title: "Sign in failed",
        exception: e,
      );
    }
  }

  void _showSignInError(PlatformException exception) {
    PlatformExceptionCustomDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signinWithApple() async {
    try {
      await model.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(e);
      } else {
        _showSignInError(e);
      }
    }
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
    SizeConfig().init(context);

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildContent(),
            model.isLoading ? LoadingScreen(isGray: true) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: constraints.maxWidth >= 700
                  ? EdgeInsets.fromLTRB(
                      SizeConfig.screenWidth / 6,
                      50,
                      SizeConfig.screenWidth / 6,
                      50,
                    )
                  : EdgeInsets.fromLTRB(25, 50, 25, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildHeader(),
                  SizedBox(height: 15),
                  _buildEmailForm(),
                  SizedBox(height: SizeConfig.safeBlockVertical * 4),
                  _buildSignInServices(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double logoHeight = SizeConfig.safeBlockVertical * 23;
        double textContainerHeight = SizeConfig.safeBlockVertical * 8;
        double fontSize = SizeConfig.safeBlockVertical * 4;
        if (constraints.maxWidth >= 700) {
          logoHeight = SizeConfig.safeBlockVertical * 12;
          textContainerHeight = SizeConfig.safeBlockVertical * 12;
          fontSize = SizeConfig.safeBlockVertical * 6;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(top: 35),
              height: logoHeight,
              child: Image.asset("assets/bonobo_logo.png"),
            ),
            Container(
              alignment: Alignment.center,
              height: textContainerHeight,
              child: Text(
                "Gifterest",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
            ),
          ],
        );
      },
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
        SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
        TermsAndConditions(model: model),
        SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
        TextButton(
          key: Key("toggle-form"),
          child: Text(
            model.secondaryText,
            style: TextStyle(
              fontSize: SizeConfig.subtitleSize,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          onPressed: model.isLoading ? null : _toogleFormType,
        ),
      ],
    );
  }

  Widget _buildSignInServices() {
    final appleSingInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return Column(
      children: <Widget>[
        Center(
          child: Text(
            model.socialMediaText,
            style: TextStyle(
              fontFamily: 'Monsterrat',
              fontSize: SizeConfig.h3Size,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.safeBlockVertical * 2),
        Row(
            mainAxisAlignment: appleSingInAvailable.isAvailable
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              appleSingInAvailable.isAvailable
                  ? CircleImageButton(
                      key: Key("apple-signin"),
                      color: Colors.grey[400],
                      textColor: Colors.white,
                      onPressed: model.isLoading ? null : _signinWithApple,
                      imagePath: 'assets/apple_logo.jpg',
                    )
                  : SizedBox.shrink(),
              CircleImageButton(
                key: Key("google-signin"),
                color: Colors.white,
                textColor: Colors.blue,
                onPressed: model.isLoading ? null : _signInWithGoogle,
                imagePath: 'assets/google_logo.jpg',
              ),
            ]),
        SizedBox(height: 25),
      ],
    );
  }
}

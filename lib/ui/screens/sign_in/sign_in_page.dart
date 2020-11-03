import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bonobo/ui/screens/sign_in/blocs/sign_in_bloc.dart';
import '../../common_widgets/circle_image_button.dart';
import 'package:bonobo/ui/common_widgets/platform_exception_alert_dialog.dart';
import 'package:bonobo/ui/screens/sign_in/widgets/email_sign_in_form.dart';

import 'package:bonobo/services/auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage({@required this.bloc});
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(bloc: bloc),
      ),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  _toggleForm() {}

  void _showSignInError(PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle() async {
    try {
      await widget.bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: widget.bloc.isLoagingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(snapshot.data);
        },
      ),
    );
  }

  SingleChildScrollView _buildContent(bool isLoading) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // HEADER
            _buildHeader(isLoading),
            SizedBox(height: 15),
            // Sign In Form
            EmailSignInForm(isLoading: isLoading),

            SizedBox(height: 15),
            FlatButton(
              child: Text(
                "Sign up",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: _toggleForm,
            ),
            SizedBox(height: 32),
            Center(
              child: Text(
                "Sign in with:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 25),
            // Social Media Sign In
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleImageButton(
                  text: "G",
                  color: Colors.white,
                  textColor: Colors.blue,
                  onPressed: isLoading ? null : _signInWithGoogle,
                ),
                CircleImageButton(
                  text: "A",
                  color: Colors.grey[400],
                  textColor: Colors.white,
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        heightFactor: 8,
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Container(
          color: Colors.yellow,
          height: 200,
        ),
        Container(
          color: Colors.red,
          height: 80,
        ),
      ],
    );
  }
}

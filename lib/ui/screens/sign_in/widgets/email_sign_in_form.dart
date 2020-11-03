import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/screens/sign_in/widgets/sign_in_text_field.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({this.isLoading});

  final bool isLoading;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submit() {
    print("submitting this user: ${_emailController.text} ...");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignInTextField(
          controller: _emailController,
          hintText: "Email",
          icon: Icons.email,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 15),
        SignInTextField(
          controller: _passwordController,
          hintText: "Password",
          icon: Icons.lock,
          textInputAction: TextInputAction.done,
          onEditingComplete: _submit,
          obscureText: true,
        ),
        SizedBox(height: 30),
        CustomButton(
          text: 'Sign in',
          color: Colors.pink[400],
          disableColor: Colors.pink[400],
          textColor: Colors.white,
          onPressed: widget.isLoading ? null : _submit,
        ),
      ],
    );
  }
}

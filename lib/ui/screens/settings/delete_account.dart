import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/services/auth.dart';
import 'package:gifterest/services/database.dart';
import 'package:gifterest/services/locator.dart';
import 'package:gifterest/ui/common_widgets/app_bar_button.dart';
import 'package:gifterest/ui/common_widgets/custom_alert_dialog/custom_alert_dialog.dart';
import 'package:gifterest/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:gifterest/ui/common_widgets/custom_app_bar.dart';
import 'package:gifterest/ui/common_widgets/custom_button.dart';
import 'package:gifterest/ui/common_widgets/custom_text_field.dart';
import 'package:gifterest/ui/common_widgets/loading_screen.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/screens/sign_in/validators.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key key}) : super(key: key);

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount>
    with EmailAndPasswordValidators {
  GlobalKey<FormState> _formKey;
  String password = "";
  bool isLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _setIsLoading(bool state) {
    setState(() {
      this.isLoading = state;
    });
  }

  void _onSubmit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    if (auth.getAuthProviderId() != 'password' || _validateAndSaveForm()) {
      try {
        // TODO: Abrir dialogo para confirmar si esta seguro el usuario

        if (await auth.isReauthenticationSuccessful(password)) {
          final yes = await WarningDialog(
            title: "Delete account?",
            content: "Are you sure want to delete account?",
            yesButtonText: 'Yes',
            noButtonText: 'No',
          ).show(context);

          // TODO: If true, await auth.deleteUserAccount(password) && await db.deleteUser(userId);
          if (yes) {
            await auth.deleteUserAccount(password, database);
          }
        }

        _setIsLoading(true);
      } on PlatformException catch (e) {
        PlatformExceptionCustomDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      } finally {
        _setIsLoading(false);
      }
    }
  }

  void _updatePassword(String value) {
    this.password = value ?? this.password;
  }

  Widget _generateWidget() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final providerId = auth.getAuthProviderId();

    switch (providerId) {
      case "google.com":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please sign in to your Google account one more time to verify you're authorized to delete the account.",
                style: TextStyle(
                  fontSize: SizeConfig.subtitleSize,
                  fontFamily: 'Nuito-Sans',
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: CustomButton(
                text: "Delete Account",
                onPressed: _onSubmit,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                color: Colors.red,
              ),
            )
          ],
        );
      case "apple.com":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please sign in to your Apple account one more time to verify you're authorized to delete the account.",
                style: TextStyle(
                  fontSize: SizeConfig.subtitleSize,
                  fontFamily: 'Nuito-Sans',
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: CustomButton(
                text: "Delete Account",
                onPressed: _onSubmit,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                color: Colors.red,
              ),
            )
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Confirm password",
              ),
            ),
            Form(
              key: _formKey,
              child: CustomTextField(
                textInputAction: TextInputAction.next,
                initialValue: "",
                labelText: "Password",
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? "Password can't be empty" : null,
                onSaved: (value) => _updatePassword(value),
                onChanged: (value) => _updatePassword(value),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: CustomButton(
                text: "Confirm",
                onPressed: _onSubmit,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              ),
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Delete Account",
        leading: AppBarButton(
          icon: LineIcons.times,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: !isLoading
          ? Container(
              padding: is700Wide
                  ? EdgeInsets.fromLTRB(
                      SizeConfig.safeBlockHorizontal * 8,
                      SizeConfig.safeBlockVertical * 3,
                      SizeConfig.safeBlockHorizontal * 8,
                      0,
                    )
                  : EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _generateWidget(),
            )
          : LoadingScreen(),
    );
  }
}

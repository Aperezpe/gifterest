import 'package:bonobo/ui/common_widgets/custom_alert_dialog/custom_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:bonobo/extensions/base_colors.dart';

class WarningDialog extends CustomAlertDialog {
  WarningDialog({
    @required String yesButtonText,
    @required String noButtonText,
    @required String title,
    @required String content,
  }) : super(
          icon: LineIcons.exclamationTriangle,
          iconColor: Color(0).warning,
          title: title,
          yesButtonText: yesButtonText,
          noButtonText: noButtonText,
          content: content,
        );
}

class ErrorDialog extends CustomAlertDialog {
  ErrorDialog({
    @required String yesButtonText,
    @required String title,
    @required String content,
  }) : super(
          icon: LineIcons.exclamationCircle,
          iconColor: Color(0).danger,
          title: title,
          yesButtonText: yesButtonText,
          content: content,
        );
}

class PlatformExceptionCustomDialog extends CustomAlertDialog {
  PlatformExceptionCustomDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
          icon: LineIcons.exclamationCircle,
          iconColor: Color(0).danger,
          title: title,
          yesButtonText: "Ok",
          content: _message(exception),
        );

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    ///  * `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
    ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.
    ///  * `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
    ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    'ERROR_WRONG_PASSWORD': 'The password is invalid',

    ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };
}

class FirebaseAuthExceptionCustomDialog extends CustomAlertDialog {
  FirebaseAuthExceptionCustomDialog({
    @required String title,
    @required FirebaseAuthException exception,
  }) : super(
          icon: LineIcons.exclamationCircle,
          iconColor: Color(0).danger,
          title: title,
          yesButtonText: "Ok",
          content: _message(exception),
        );

  static String _message(FirebaseAuthException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'wrong-password': 'The password is invalid',
  };
}

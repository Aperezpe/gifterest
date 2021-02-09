import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthExceptionAlertDialog extends PlatformAlertDialog {
  FirebaseAuthExceptionAlertDialog({
    @required String title,
    @required FirebaseAuthException exception,
  }) : super(
          title: title,
          content: _message(exception),
          defaultAtionText: 'OK',
        );

  static String _message(FirebaseAuthException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'wrong-password': 'The password is invalid',
  };
}

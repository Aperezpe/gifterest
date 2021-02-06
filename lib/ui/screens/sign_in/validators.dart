import 'dart:core';
import 'package:email_validator/email_validator.dart' as emailV;

abstract class StringValidator {
  String get errorMessage;
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  String get errorMessage => "Name can't be empty";

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailValidator implements StringValidator {
  String _errorMessage = "Invalid Email";
  @override
  String get errorMessage => _errorMessage;

  @override
  bool isValid(String value) {
    if (value.isEmpty) {
      _errorMessage = "Email can't be empty";
      return false;
    }

    _errorMessage = "Invalid Email Format";
    return emailV.EmailValidator.validate(value);
  }
}

class PasswordValidator implements StringValidator {
  String _errorMessage = "Invalid Password";
  @override
  String get errorMessage => _errorMessage;

  @override
  bool isValid(String value) {
    if (value.isEmpty) {
      _errorMessage = "Password can't be empty";
      return false;
    }

    if (value.length < 6) {
      _errorMessage = "Password is too short";
      return false;
    }

    return true;
  }
}

class RetypePasswordValidator {
  String _errorMessage = "Invalid Password";
  String get errorMessage => _errorMessage;

  bool isValid(String value, String value2) {
    if (value.isEmpty) {
      _errorMessage = "Password can't be empty";
      return false;
    }

    if (value != value2) {
      _errorMessage = "Passwords doesn't match";
      return false;
    }

    return true;
  }
}

class EmailAndPasswordValidators {
  final StringValidator nameValidator = NonEmptyStringValidator();
  final StringValidator emailValidator = EmailValidator();
  final StringValidator passwordValidator = PasswordValidator();
  final RetypePasswordValidator retypePasswordValidator =
      RetypePasswordValidator();
  String get invalidNameErrorText => nameValidator.errorMessage;
  String get invalidEmailErrorText => emailValidator.errorMessage;
  String get invalidPasswordErrorText => passwordValidator.errorMessage;
  String get invalidRetypePasswordErrorText =>
      retypePasswordValidator.errorMessage;
}

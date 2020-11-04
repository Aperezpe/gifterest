class NameValidator {
  static String validate(String text) {
    if (text.isEmpty)
      return "Name can't be empty";
    else
      return null;
  }
}

class EmailValidator {
  static String validate(String text) {
    if (text.isEmpty)
      return "Email can't be empty";
    else
      return null;
  }
}

class PasswordValidator {
  static String validate(String text) {
    if (text.isEmpty)
      return "Password can't be empty";
    else
      return null;
  }
}

class RetypePasswordValidator {
  static String validate(String pw1, String pw2) {
    if (pw1.isEmpty || pw2.isEmpty) {
      return "Password can't be empty";
    } else if (pw1 != pw2) {
      return "Passwords are not the same";
    } else
      return null;
  }
}

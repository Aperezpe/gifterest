import 'package:bonobo/ui/screens/sign_in/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NonEmptyStringValidator stringValidator;
  EmailValidator emailValidator;
  PasswordValidator passwordValidator;
  RetypePasswordValidator retypePasswordValidator;

  setUp(() {
    stringValidator = NonEmptyStringValidator();
    emailValidator = EmailValidator();
    passwordValidator = PasswordValidator();
    retypePasswordValidator = RetypePasswordValidator();
  });

  group('Name: ', () {
    test('Non-empty string is VALID', () {
      final isValid = stringValidator.isValid("Abraham");
      expect(isValid, true);
    });
    test('Empty or longer than 32 char is INVALID', () {
      var isValid = stringValidator.isValid("");
      expect(isValid, false);
      isValid = stringValidator.isValid("qwertyuiopasdfghjklzxcvbnm123456789");
      expect(isValid, false);
    });
  });

  group('Email: ', () {
    test('Correct format email is VALID', () {
      final isValid = emailValidator.isValid("test@test.com");
      expect(isValid, true);
    });
    test('Wrong format email is INVALID', () {
      var isValid = emailValidator.isValid("invalid");
      expect(isValid, false);
      isValid = emailValidator.isValid("");
      expect(isValid, false);
    });
  });

  group('Password: ', () {
    test('More than 6 characters is VALID', () {
      final isValid = passwordValidator.isValid("1234567");
      expect(isValid, true);
    });
    test('Empty or less than 6 characters is INVALID', () {
      var isValid = passwordValidator.isValid("");
      expect(isValid, false);
      isValid = passwordValidator.isValid("12345");
    });
  });
  group('Retype Password: ', () {
    test('Matching passwords are VALID', () {
      var isValid = retypePasswordValidator.isValid("1234567", "1234567");
      expect(isValid, true);
      isValid = retypePasswordValidator.isValid("1234567", "asdqwef");
      expect(isValid, false);
    });
  });
}

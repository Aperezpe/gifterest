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

  group('Name: ', () {});
  test('name is valid if not empty', () {});
}

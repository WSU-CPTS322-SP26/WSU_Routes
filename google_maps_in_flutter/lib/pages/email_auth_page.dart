import 'dart:math';

import 'package:email_validator/email_validator.dart';

void main() {
  String email = "example@example.com";
  final bool isValid = EmailValidator.validate(email);

  print('Is the email valid? ${isValid ? 'Yes' : 'No'}');
}
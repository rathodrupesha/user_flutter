import 'package:flutter/cupertino.dart';
import 'WidgetUtils.dart';

class Validations {
  final BuildContext context;

  Validations(this.context);

  bool loginValidations(String email, String passwd) {
    if (email == "") {
      WidgetUtils().customToastMsg('error_enter_email');
      return false;
    }
    if (passwd == "") {
      WidgetUtils().customToastMsg('error_enter_password');
      return false;
    } else {
      return true;
    }
  }

  bool bookingServiceValidations(String txt) {
    if (txt == "") {
      WidgetUtils().customToastMsg('Enter your additional text.');
      return false;
    } else {
      return true;
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

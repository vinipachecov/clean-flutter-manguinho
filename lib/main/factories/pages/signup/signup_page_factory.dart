import 'package:flutter/material.dart';
import 'signup_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSignUpPage() {
  return SignUpPage(presenter: makeGetxSignUpPresenter());
}
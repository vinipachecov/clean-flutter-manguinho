import 'package:flutter/material.dart';
import 'login_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}
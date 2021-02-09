import 'package:flutter/material.dart';
import 'login_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';
import 'package:get/get.dart';

Widget makeLoginPage() {
  final presenter = Get.put<LoginPresenter>(makeGetxLoginPresenter());
  return LoginPage(presenter);
}
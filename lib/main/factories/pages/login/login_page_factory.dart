import 'package:clean_flutter_manguinho/data/usecases/remote_authentication.dart';
import 'package:flutter/material.dart';
import '../login/login_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';

Widget makeLoginPage() {
  return LoginPage(makeLoginPresenter());
}
import 'package:flutter/material.dart';
import 'splash_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter(),);
}
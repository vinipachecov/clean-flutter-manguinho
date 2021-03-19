import 'package:get/get.dart';

import './splash_presenter.dart';
import 'package:flutter/material.dart';


class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      appBar: AppBar(title: Text('Company'),),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return Center(child: CircularProgressIndicator());
      },)
    );
  }
}

import './splash_presenter.dart';
import 'package:flutter/material.dart';
import '../../mixins/mixins.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  SplashPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
        appBar: AppBar(
          title: Text('Company'),
        ),
        body: Builder(
          builder: (context) {
            handleNavigation(presenter.navigateToStream, clear: true);

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

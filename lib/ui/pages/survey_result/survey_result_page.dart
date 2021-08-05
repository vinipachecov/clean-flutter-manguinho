import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/components/spinner_dialog.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import './components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;
  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.strings.surveys)),
        body: Builder(
          builder: (ctx) {
            presenter.isLoadingStream.listen((isLoading) {
              if (isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            });

            this.presenter.loadData();
            return StreamBuilder<SurveyResultViewModel>(
                stream: presenter.surveyResultStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                        error: snapshot.error, reload: presenter.loadData);
                  }
                  if (snapshot.hasData) {
                    return SurveyResult(snapshot.data);
                  }
                  return SizedBox(height: 0);
                });
          },
        ));
  }
}

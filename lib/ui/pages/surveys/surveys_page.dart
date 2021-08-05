import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import './components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.strings.surveys)),
        body: Builder(
          builder: (context) {
            presenter.isLoadingStream.listen((isLoading) {
              if (isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            });
            presenter.loadData();

            return StreamBuilder<List<SurveyViewModel>>(
                stream: presenter.surveysStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                        error: snapshot.error, reload: presenter.loadData);
                  }
                  if (snapshot.hasData) {
                    return SurveyItems(snapshot.data);
                  }
                  return SizedBox(height: 0);
                });
          },
        ));
  }
}

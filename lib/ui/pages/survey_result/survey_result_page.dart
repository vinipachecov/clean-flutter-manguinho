import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import './components/components.dart';
import '../../mixins/mixins.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;
  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.strings.surveys)),
        body: Builder(
          builder: (ctx) {
            handleLoading(context, presenter.isLoadingStream);

            handleSession(presenter.isSessionExpiredStream);

            this.presenter.loadData();
            return StreamBuilder<SurveyResultViewModel>(
                stream: presenter.surveyResultStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                        error: snapshot.error, reload: presenter.loadData);
                  }
                  if (snapshot.hasData) {
                    return SurveyResult(
                        viewModel: snapshot.data, onSave: presenter.save);
                  }
                  return SizedBox(height: 0);
                });
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';
import 'package:provider/provider.dart';
import './components/components.dart';
import '../../mixins/mixins.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.strings.surveys)),
        body: Builder(
          builder: (context) {
            handleLoading(context, presenter.isLoadingStream);

            handleSession(presenter.isSessionExpiredStream);

            handleNavigation(presenter.navigateToStream);

            presenter.loadData();

            return StreamBuilder<List<SurveyViewModel>>(
                stream: presenter.surveysStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                        error: snapshot.error, reload: presenter.loadData);
                  }
                  if (snapshot.hasData) {
                    return Provider(
                        create: (_) => presenter,
                        child: SurveyItems(snapshot.data));
                  }
                  return SizedBox(height: 0);
                });
          },
        ));
  }
}

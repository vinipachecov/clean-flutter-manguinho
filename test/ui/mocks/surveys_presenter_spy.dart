import 'dart:async';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final isLoadingController = StreamController<bool>();
  final surveysController = StreamController<List<SurveyViewModel>>();
  final navigateToController = StreamController<String>();
  final isSessionExpiredController = StreamController<bool>();

  SurveysPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => null);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveysStream)
        .thenAnswer((realInvocation) => this.surveysController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void emitIsLoading([bool show = true]) {
    this.isLoadingController.add(show);
  }

  void emitSessionExpired([bool expired = true]) {
    this.isSessionExpiredController.add(expired);
  }

  void emitNavigateTo(String route) {
    this.navigateToController.add(route);
  }

  void emitSurveys(List<SurveyViewModel> data) {
    this.surveysController.add(data);
  }

  void emitSurveysError(String error) {
    this.surveysController.addError(error);
  }

  void dispose() {
    isLoadingController.close();
    surveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }
}

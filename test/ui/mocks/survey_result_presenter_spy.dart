import 'dart:async';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final isLoadingController = StreamController<bool>();
  final surveyResultController = StreamController<SurveyResultViewModel?>();
  final isSessionExpiredController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => null);
    when(() => this.save(answer: any(named: 'answer')))
        .thenAnswer((_) async => null);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveyResultStream)
        .thenAnswer((realInvocation) => surveyResultController.stream);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((realInvocation) => isSessionExpiredController.stream);
  }

  void emitIsLoading([bool show = true]) {
    this.isLoadingController.add(show);
  }

  void emitSessionExpired([bool expired = true]) {
    this.isSessionExpiredController.add(expired);
  }

  void emitSurveyResult(SurveyResultViewModel data) {
    this.surveyResultController.add(data);
  }

  void emitSurveyResultError(String error) {
    this.surveyResultController.addError(error);
  }

  void dispose() {
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  }
}

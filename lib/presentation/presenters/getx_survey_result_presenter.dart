import 'package:clean_flutter_manguinho/presentation/mixins/mixins.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class GetxLoadSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxLoadSurveyResultPresenter(
      {@required this.loadSurveyResult, this.surveyId});

  Future<void> loadData() async {
    try {
      isLoading = true;
      final survey = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      // Map de SurveyEntity para SurveyViewModel
      _surveyResult.value = SurveyResultViewModel(
          surveyId: survey.surveyId,
          question: survey.question,
          answers: survey.answers
              .map((answer) => SurveyAnswerViewModel(
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}%'))
              .toList());
      isLoading = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> save({String answer}) {}
}

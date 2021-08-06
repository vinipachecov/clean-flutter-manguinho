import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class GetxLoadSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxLoadSurveyResultPresenter(
      {@required this.loadSurveyResult, this.surveyId});

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
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
      _isLoading.value = false;
    } on DomainError {
      _surveyResult.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}

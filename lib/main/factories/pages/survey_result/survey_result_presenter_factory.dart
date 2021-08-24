import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../main/factories/usecases/usecases.dart';

/*
 * Requires surveyId to create the URL appropriately.
 */
SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxLoadSurveyResultPresenter(
      loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
      saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
      surveyId: surveyId);
}

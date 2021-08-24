import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
      url: makeApiUrl('surveys/$surveyId/results'),
      httpClient: makeAuthorizeHttpClientDecorator());
}

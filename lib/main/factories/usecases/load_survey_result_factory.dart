import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
      url: makeApiUrl('surveys/$surveyId/results'),
      httpClient: makeAuthorizeHttpClientDecorator());
}

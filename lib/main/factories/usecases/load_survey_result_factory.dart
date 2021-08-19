import 'package:clean_flutter_manguinho/main/composites/remote_load_survey_result_with_local_fallback.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

// Example of Liskov Substitution principle ***
LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
      url: makeApiUrl('surveys/$surveyId/results'),
      httpClient: makeAuthorizeHttpClientDecorator());
}

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
        remote: makeRemoteLoadSurveyResult(surveyId),
        local: makeLocalLoadSurveyResult(surveyId));

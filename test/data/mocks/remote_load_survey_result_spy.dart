import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadBySurvey(SurveyResultEntity remoteResult) {
    mockLoadBySurveyCall().thenAnswer((realInvocation) async => remoteResult);
  }

  void mockLoadBySurveyError(DomainError error) =>
      mockLoadBySurveyCall().thenThrow(error);
}

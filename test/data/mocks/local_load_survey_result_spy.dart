import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    this.mockValidate();
    this.mockSave();
  }
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadBySurvey(SurveyResultEntity surveyResult) =>
      mockLoadBySurveyCall().thenAnswer((realInvocation) async => surveyResult);

  mockLoadBySurveyError() =>
      mockLoadBySurveyCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  mockValidateError() => mockLoadBySurveyCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  mockSaveError() => mockLoadBySurveyCall().thenThrow(Exception());
}

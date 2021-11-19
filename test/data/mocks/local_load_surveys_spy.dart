import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {
  LocalLoadSurveysSpy() {
    this.mockValidate();
    this.mockSave();
  }

  When mockLoadSurveysCall() => when(() => this.load());
  void mockLoadSurveys(List<SurveyEntity> localSurveys) =>
      mockLoadSurveysCall().thenAnswer((_) async => localSurveys);
  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate());
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  mockSaveError() => mockSaveCall().thenThrow(Exception());
}

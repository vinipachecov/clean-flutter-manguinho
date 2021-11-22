import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/usecases/save_survey_result.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveSurveyResultCall() =>
      when(() => this.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    mockSaveSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockSaveSurveyResultError(error) {
    mockSaveSurveyResultCall().thenThrow(error);
  }
}

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/presentation/presenters/presenters.dart';
import 'package:clean_flutter_manguinho/ui/pages/survey_result/survey_result.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  // use case
  LoadSurveyResultSpy loadSurveyResultSpy;
  SaveSurveyResultSpy saveSurveyResultSpy;

  // presenter that will ingest the use case
  GetxLoadSurveyResultPresenter sut;

  // data returned from the use case
  SurveyResultEntity surveyResult;
  String surveyId;

  //
  String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                image: faker.internet.httpUrl(),
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100)),
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100))
          ]);

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
  }

  void mockAccessDeniedError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);
  }

  setUp(() {
    // Mock Dependencies - use case
    loadSurveyResultSpy = LoadSurveyResultSpy();
    saveSurveyResultSpy = SaveSurveyResultSpy();
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();

    // System Under Test
    sut = GetxLoadSurveyResultPresenter(
        loadSurveyResult: loadSurveyResultSpy,
        saveSurveyResult: saveSurveyResultSpy,
        surveyId: surveyId);

    // Mock Success Case
    mockLoadSurveyResult(mockValidData());
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResultSpy.save(answer: answer)).called(1);
    });
  });
}

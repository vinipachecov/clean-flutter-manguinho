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

void main() {
  // use case
  LoadSurveyResultSpy loadSurveyResultSpy;

  // presenter that will ingest the use case
  GetxLoadSurveyResultPresenter sut;

  // data returned from the use case
  SurveyResultEntity surveyResult;
  String surveyId;

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

  setUp(() {
    // Mock Dependencies - use case
    loadSurveyResultSpy = LoadSurveyResultSpy();
    surveyId = faker.guid.guid();

    // System Under Test
    sut = GetxLoadSurveyResultPresenter(
        loadSurveyResult: loadSurveyResultSpy, surveyId: surveyId);

    // Mock Success Case
    mockLoadSurveyResult(mockValidData());
  });

  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((result) => expect(
          result,
          SurveyResultViewModel(
              surveyId: surveyResult.surveyId,
              question: surveyResult.question,
              answers: [
                SurveyAnswerViewModel(
                    image: surveyResult.answers[0].image,
                    answer: surveyResult.answers[0].answer,
                    isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                    percent: '${surveyResult.answers[0].percent}%'),
                SurveyAnswerViewModel(
                    answer: surveyResult.answers[1].answer,
                    isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                    percent: '${surveyResult.answers[1].percent}%')
              ]),
        )));
    await sut.loadData();

    verify(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveyResultError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));
    await sut.loadData();
  });
}

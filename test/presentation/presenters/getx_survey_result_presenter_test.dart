import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/presentation/presenters/presenters.dart';
import 'package:clean_flutter_manguinho/ui/pages/survey_result/survey_result.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  // use case
  late LoadSurveyResultSpy loadSurveyResultSpy;
  late SaveSurveyResultSpy saveSurveyResultSpy;

  // presenter that will ingest the use case
  late GetxLoadSurveyResultPresenter sut;

  // data returned from the use case
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) =>
      SurveyResultViewModel(
          surveyId: entity.surveyId,
          question: entity.question,
          answers: [
            SurveyAnswerViewModel(
                image: entity.answers[0].image,
                answer: entity.answers[0].answer,
                isCurrentAnswer: entity.answers[0].isCurrentAnswer,
                percent: '${entity.answers[0].percent}%'),
            SurveyAnswerViewModel(
                answer: entity.answers[1].answer,
                isCurrentAnswer: entity.answers[1].isCurrentAnswer,
                percent: '${entity.answers[1].percent}%')
          ]);

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
    loadResult = EntityFactory.makeSurveyResult();
    loadSurveyResultSpy.mockLoadBySurvey(loadResult);
    saveResult = EntityFactory.makeSurveyResult();
    saveSurveyResultSpy.mockSaveSurveyResult(saveResult);
  });

  group('loadData', () {
    test('Should call loadSurveys on loadData', () async {
      await sut.loadData();

      verify(() => loadSurveyResultSpy.loadBySurvey(surveyId: surveyId))
          .called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) {
        final viewModel = mapToViewModel(loadResult);
        expect(result, viewModel);
      }));
      await sut.loadData();

      verify(() => loadSurveyResultSpy.loadBySurvey(surveyId: surveyId))
          .called(1);
    });

    test('Should emit correct events on failure', () async {
      loadSurveyResultSpy.mockLoadBySurveyError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));
      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      loadSurveyResultSpy.mockLoadBySurveyError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResultSpy.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.surveyResultStream,
          emitsInOrder(
              [mapToViewModel(loadResult), mapToViewModel(saveResult)]));

      await sut.loadData();
      await sut.save(answer: answer);

      verify(() => saveSurveyResultSpy.save(answer: answer)).called(1);
    });

    test('Should emit correct events on failure', () async {
      saveSurveyResultSpy.mockSaveSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));
      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      saveSurveyResultSpy.mockSaveSurveyResultError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      await sut.save(answer: answer);
    });
  });
}

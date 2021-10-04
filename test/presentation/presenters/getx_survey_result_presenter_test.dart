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

import '../../mocks/fake_survey_result_factory.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  // use case
  LoadSurveyResultSpy loadSurveyResultSpy;
  SaveSurveyResultSpy saveSurveyResultSpy;

  // presenter that will ingest the use case
  GetxLoadSurveyResultPresenter sut;

  // data returned from the use case
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;

  //
  String answer;

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(error) {
    mockLoadSurveyResultCall().thenThrow(error);
  }

  PostExpectation mockSaveSurveyResultCall() =>
      when(saveSurveyResultSpy.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(error) {
    mockSaveSurveyResultCall().thenThrow(error);
  }

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
    mockLoadSurveyResult(FakeSurveyResultFactory.makeEntity());
    mockSaveSurveyResult(FakeSurveyResultFactory.makeEntity());
  });

  group('loadData', () {
    test('Should call loadSurveys on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) {
        final viewModel = mapToViewModel(loadResult);
        expect(result, viewModel);
      }));
      await sut.loadData();

      verify(loadSurveyResultSpy.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));
      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResultSpy.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.surveyResultStream,
          emitsInOrder(
              [mapToViewModel(loadResult), mapToViewModel(saveResult)]));

      await sut.loadData();
      await sut.save(answer: answer);

      verify(saveSurveyResultSpy.save(answer: answer)).called(1);
    });

    test('Should emit correct events on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));
      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      await sut.save(answer: answer);
    });
  });
}

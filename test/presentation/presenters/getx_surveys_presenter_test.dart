import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/survey_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/domain/usecases/load_surveys.dart';

import 'package:clean_flutter_manguinho/presentation/presenters/getx_surveys_presenter.dart';

import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';

import '../../mocks/mocks.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;

  PostExpectation mockloadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockloadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() {
    mockloadSurveysCall().thenThrow(DomainError.unexpected);
  }

  void mockAccessDeniedError() {
    mockloadSurveysCall().thenThrow(DomainError.accessDenied);
  }

  setUp(() {
    // Mock Dependencies
    loadSurveys = LoadSurveysSpy();

    // System Under Test
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    // Mock Success Case
    mockLoadSurveys(FakeSurveysFactory.makeEntities());
  });
  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: '02 Feb 2020',
              didAnswer: surveys[0].didAnswer),
          SurveyViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: '20 Dec 2018',
              didAnswer: surveys[1].didAnswer),
        ])));
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));
    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));
    await sut.loadData();
  });

  test('Should go to SurveyResult page on survey click', () async {
    expectLater(sut.navigateToStream,
        emitsInOrder(['/survey_result/1', '/survey_result/1']));

    sut.goToSurveyResult('1');
    sut.goToSurveyResult('1');
  });
}

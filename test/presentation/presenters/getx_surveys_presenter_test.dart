import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/survey_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';

import 'package:clean_flutter_manguinho/presentation/presenters/getx_surveys_presenter.dart';

import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';

import '../../domain/mocks/load_surveys_spy.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  setUp(() {
    // Mock Dependencies
    loadSurveys = LoadSurveysSpy();

    // System Under Test
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    surveys = EntityFactory.makeSurveyList();

    // Mock Success Case
    loadSurveys.mockLoadSurveys(surveys);
  });
  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
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

    verify(() => loadSurveys.load()).called(1);
  });

  test('Should emit correct events on failure', () async {
    loadSurveys.mockLoadSurveysError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));
    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    loadSurveys.mockLoadSurveysError(DomainError.accessDenied);
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

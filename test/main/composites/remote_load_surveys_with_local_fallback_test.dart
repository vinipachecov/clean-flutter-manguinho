import 'package:clean_flutter_manguinho/main/composites/composites.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';

import '../../data/mocks/local_load_surveys_spy.dart';

import '../../data/mocks/remote_load_surveys_spy.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late RemoteLoadSurveysWithLocalFallback sut;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    remoteSurveys = EntityFactory.makeSurveyList();
    localSurveys = EntityFactory.makeSurveyList();
    remote.mockLoadSurveys(remoteSurveys);
    local.mockLoadSurveys(localSurveys);
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
  });
  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    remote.mockLoadSurveysError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockLoadSurveysError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    remote.mockLoadSurveysError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedErro if remote and local throws', () async {
    remote.mockLoadSurveysError(DomainError.unexpected);
    local.mockLoadSurveysError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:clean_flutter_manguinho/main/composites/composites.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';

import '../../mocks/fake_surveys_factory.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  RemoteLoadSurveysWithLocalFallback sut;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = FakeSurveysFactory.makeEntities();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = FakeSurveysFactory.makeEntities();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) {
    mockRemoteLoadCall().thenThrow(error);
  }

  void mockLocalLoadError() {
    mockLocalLoadCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });
  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedErro if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

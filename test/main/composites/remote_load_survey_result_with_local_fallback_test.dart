import 'package:clean_flutter_manguinho/main/composites/composites.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    surveyId = faker.guid.guid();
    local = LocalLoadSurveyResultSpy();
    remote = RemoteLoadSurveyResultSpy();
    remoteResult = EntityFactory.makeSurveyResult();
    localResult = EntityFactory.makeSurveyResult();
    local.mockLoadBySurvey(localResult);
    remote.mockLoadBySurvey(remoteResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId));
  });

  test("Should call local save with remote data", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteResult));
  });

  test("Should return remote data", () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test("Should return rethrow if loadBySurvey throws AccessDeniedError",
      () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test("Should call loadBySurvey on remote error", () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Should return local data", () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test("Should throw unexpectedError if local load fails", () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:clean_flutter_manguinho/main/composites/composites.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  RemoteLoadSurveyResultWithLocalFallback sut;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  SurveyResultEntity mockSurveyResult() => remoteResult = SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100))
          ]);

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  PostExpectation mockLocalLoadCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  void mockRemoteLoad() {
    remoteResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((realInvocation) async => remoteResult);
  }

  void mockLocalLoad() {
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((realInvocation) async => localResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    local = LocalLoadSurveyResultSpy();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });
  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId));
  });

  test("Should call local save with remote data", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(remoteResult));
  });

  test("Should return remote data", () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test("Should return rethrow if loadBySurvey throws AccessDeniedError",
      () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test("Should call loadBySurvey on remote error", () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Should return local data", () async {
    mockRemoteLoadError(DomainError.unexpected);
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test("Should throw unexpectedError if local load fails", () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: surveyResult);
    return surveyResult;
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  RemoteLoadSurveyResultWithLocalFallback sut;
  SurveyResultEntity surveyResult;

  SurveyResultEntity mockSurveyResult() => surveyResult = SurveyResultEntity(
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

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((realInvocation) async => surveyResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    local = LocalLoadSurveyResultSpy();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
  });
  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId));
  });

  test("Should call local save with remote data", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: surveyResult));
  });

  test("Should return remote data", () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
  });

  test("Should return rethrow if loadBySurvey throws AccessDeniedError",
      () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}

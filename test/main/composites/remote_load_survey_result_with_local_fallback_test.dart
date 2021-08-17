import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<void> loadBySurvey({String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: surveyResult);
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

  void mockSurveyResult() {
    surveyResult = SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100))
        ]);
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenAnswer((realInvocation) async => surveyResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    local = LocalLoadSurveyResultSpy();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult();
  });
  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId));
  });

  test("Should call local save with remote data", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: surveyResult));
  });
}

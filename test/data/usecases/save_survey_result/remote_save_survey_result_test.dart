import 'dart:io';
import 'package:clean_flutter_manguinho/data/http/http_error.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteSaveSurveyResult sut;
  String answer;
  Map surveyResult;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpError(error) => mockRequest().thenThrow(error);

  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          }
        ],
        'date': faker.date.dateTime().toIso8601String()
      };

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    answer = faker.lorem.sentence();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });

  test('Should return survey result on 200', () async {
    final result = await sut.save(answer: answer);

    expect(
        result,
        SurveyResultEntity(
            surveyId: surveyResult['surveyId'],
            question: surveyResult['question'],
            answers: [
              SurveyAnswerEntity(
                image: surveyResult['answers'][0]['image'],
                answer: surveyResult['answers'][0]['answer'],
                isCurrentAnswer: surveyResult['answers'][0]
                    ['isCurrentAccountAnswer'],
                percent: surveyResult['answers'][0]['percent'],
              ),
              SurveyAnswerEntity(
                answer: surveyResult['answers'][1]['answer'],
                isCurrentAnswer: surveyResult['answers'][1]
                    ['isCurrentAccountAnswer'],
                percent: surveyResult['answers'][1]['percent'],
              )
            ]));
  });

  test(
      'Should throw UnexpectedError if httpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_key'});

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw accessDenied if httpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
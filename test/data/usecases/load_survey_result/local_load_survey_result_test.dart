import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('loadBySurvey', () {
    CacheStorageSpy cacheStorageSpy;
    LocalLoadSurveyResult sut;
    String surveyId;
    Map data;

    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'true',
              'percent': '40'
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'false',
              'percent': '60'
            }
          ],
        };

    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() =>
        mockFetchCall().thenThrow((_) async => Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
      mockFetch(mockValidData());
    });
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorageSpy.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return a surveyResult on success', () async {
      when(cacheStorageSpy.fetch(any)).thenAnswer((_) async => data);
      final surveys = await sut.loadBySurvey(surveyId: surveyId);

      expect(
          surveys,
          SurveyResultEntity(
              surveyId: data['surveyId'],
              question: data['question'],
              answers: [
                SurveyAnswerEntity(
                    image: data['answers'][0]['image'],
                    answer: data['answers'][0]['answer'],
                    isCurrentAnswer: true,
                    percent: 40),
                SurveyAnswerEntity(
                    answer: data['answers'][1]['answer'],
                    isCurrentAnswer: false,
                    percent: 60)
              ]));
    });

    test('Should throw unexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is invalid', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int'
          },
        ],
      });

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is incomplete', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
      });

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

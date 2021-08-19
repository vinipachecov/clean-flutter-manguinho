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
  group('validate', () {
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
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorageSpy.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
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

      await sut.validate(surveyId);

      verify(cacheStorageSpy.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();
      await sut.validate(surveyId);

      verify(cacheStorageSpy.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    CacheStorageSpy cacheStorageSpy;
    LocalLoadSurveyResult sut;
    SurveyResultEntity surveyResult;

    PostExpectation mockSaveCall() => when(
        cacheStorageSpy.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow((_) async => Exception());

    SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
            surveyId: faker.guid.guid(),
            question: faker.lorem.sentence(),
            answers: [
              SurveyAnswerEntity(
                  image: faker.internet.httpUrl(),
                  answer: faker.lorem.sentence(),
                  isCurrentAnswer: true,
                  percent: 40),
              SurveyAnswerEntity(
                  answer: faker.lorem.sentence(),
                  isCurrentAnswer: false,
                  percent: 60)
            ]);

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
      surveyResult = mockSurveyResult();
    });
    test('Should call cacheStorage with correct values', () async {
      final json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true'
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false'
          }
        ]
      };

      await sut.save(surveyResult);

      verify(cacheStorageSpy.save(
              key: 'survey_result/${surveyResult.surveyId}', value: json))
          .called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

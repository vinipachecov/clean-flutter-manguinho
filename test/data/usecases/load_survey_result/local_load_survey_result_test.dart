import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/cache_storage_spy.dart';

void main() {
  late CacheStorageSpy cacheStorageSpy;
  late LocalLoadSurveyResult sut;
  late SurveyResultEntity surveyResult;
  late String surveyId;
  late Map data;

  setUp(() {
    surveyId = faker.guid.guid();
    cacheStorageSpy = CacheStorageSpy();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
    data = CacheFactory.makeSurveyResult();
    surveyResult = EntityFactory.makeSurveyResult();
    cacheStorageSpy.mockFetch(data);
  });
  group('loadBySurvey', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorageSpy.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return a surveyResult on success', () async {
      when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => data);
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

    test('Should throw unexpectedError if cache is invalid', () async {
      cacheStorageSpy.mockFetch(CacheFactory.makeInvalidSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is incomplete', () async {
      cacheStorageSpy.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache throws', () async {
      cacheStorageSpy.mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });
  });
  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorageSpy.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorageSpy.mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorageSpy.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      cacheStorageSpy.mockFetchError();
      await sut.validate(surveyId);

      verify(() => cacheStorageSpy.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
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

      verify(() => cacheStorageSpy.save(
          key: 'survey_result/${surveyResult.surveyId}',
          value: json)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      cacheStorageSpy.mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

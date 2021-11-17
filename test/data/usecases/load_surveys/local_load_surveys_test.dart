import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    late CacheStorageSpy cacheStorageSpy;
    late LocalLoadSurveys sut;
    late List<Map> data;

    When mockFetchCall() => when(() => cacheStorageSpy.fetch(any()));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() =>
        mockFetchCall().thenThrow((_) async => Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
      mockFetch(CacheFactory.makeSurveyList());
    });
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorageSpy.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      when(() => cacheStorageSpy.fetch(any())).thenAnswer((_) async => data);
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2020, 7, 20),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2019, 2, 2),
            didAnswer: true)
      ]);
    });

    test('Should throw unexpectedError if cache is invalid', () async {
      mockFetch(CacheFactory.makeInvalidSurveyList());

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyList());

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });
  });
  group('validate', () {
    late CacheStorageSpy cacheStorageSpy;
    late LocalLoadSurveys sut;
    late List<Map> data;

    When mockFetchCall() => when(() => cacheStorageSpy.fetch(any()));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() =>
        mockFetchCall().thenThrow((_) async => Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
      mockFetch(CacheFactory.makeSurveyList());
    });
    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorageSpy.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyList());
      await sut.validate();

      verify(() => cacheStorageSpy.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyList());
      await sut.validate();

      verify(() => cacheStorageSpy.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();
      await sut.validate();

      verify(() => cacheStorageSpy.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late CacheStorageSpy cacheStorageSpy;
    late LocalLoadSurveys sut;
    late List<SurveyEntity> surveys;

    When mockSaveCall() => when(() => cacheStorageSpy.save(
        key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveError() => mockSaveCall().thenThrow((_) async => Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
      surveys = EntityFactory.makeSurveyList();
    });
    test('Should call cacheStorage with correct values', () async {
      // pass a list of surveys json
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-02-02T00:00:00.000Z',
          'didAnswer': 'true'
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2018-12-20T00:00:00.000Z',
          'didAnswer': 'false'
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorageSpy.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

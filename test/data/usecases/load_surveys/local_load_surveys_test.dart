import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    CacheStorageSpy cacheStorageSpy;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2020-07-20T00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-02-02T00:00:00Z',
            'didAnswer': 'true',
          }
        ];

    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() =>
        mockFetchCall().thenThrow((_) async => Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
      mockFetch(mockValidData());
    });
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorageSpy.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      when(cacheStorageSpy.fetch(any)).thenAnswer((_) async => data);
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

    test('Should throw unexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw unexpectedError if cache is incomplete', () async {
      mockFetchError();

      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });
  });
  group('validate', () {
    CacheStorageSpy cacheStorageSpy;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2020-07-20T00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-02-02T00:00:00Z',
            'didAnswer': 'true',
          }
        ];

    PostExpectation mockFetchCall() => when(cacheStorageSpy.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() =>
        mockFetchCall().thenThrow((_) async => Exception());

    setUp(() {
      cacheStorageSpy = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);
      mockFetch(mockValidData());
    });
    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(cacheStorageSpy.fetch('surveys')).called(1);
    });
  });
}

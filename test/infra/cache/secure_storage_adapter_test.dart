import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/infra/cache/cache.dart';
import '../mocks/mocks.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late SecureStorageAdapter sut;
  late String key;
  late String value;
  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    value = faker.guid.guid();
    secureStorage.mockFetch(value);
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
  });

  group('saveSecure', () {
    test('Should cal lsave secure with correct values', () async {
      await sut.save(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if saveSecure throws', () async {
      secureStorage.mockSaveError();
      final future = sut.save(key: key, value: value);

      // If we ensure the method calls returns any exception
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call fetch secure with correct value', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });
    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throws', () async {
      secureStorage.mockFetchError();
      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
  group('delete', () {
    test('Should call secureStorage with correct values', () async {
      await sut.delete(key);
      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      secureStorage.mockDeleteError();
      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}

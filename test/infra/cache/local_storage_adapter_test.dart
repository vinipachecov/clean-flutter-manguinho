import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:clean_flutter_manguinho/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  FlutterSecureStorage secureStorage;

  LocalStorageAdapter({this.secureStorage});

  Future<void> saveSecure({@required String key, @required String value}) async {
    await this.secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {

  FlutterSecureStorageSpy secureStorage;
  LocalStorageAdapter sut;
  String key;
  String value;

  void mocksaveSecureError() {
  when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
}
  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });
  test('Should cal lsave secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);
    verify(secureStorage.write(key: key, value: value));
  });

  test('Should throw if saveSecure throws', () async {
    mocksaveSecureError();
    final future = sut.saveSecure(key: key, value: value);

    // If we ensure the method calls returns any exception
    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}


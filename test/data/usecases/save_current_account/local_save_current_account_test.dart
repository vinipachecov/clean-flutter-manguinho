import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount{
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({ this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}
void main() {

  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;


  setUp(() {
    saveSecureCacheStorage =  SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(key: anyNamed('key'), value: anyNamed('value')))
    .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw an UnexpectedError if SaveSecureCacheStorage throws', () async {
    mockError();


    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
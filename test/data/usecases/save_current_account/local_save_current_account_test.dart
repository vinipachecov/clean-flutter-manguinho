import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount{
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({ this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}
void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final saveSecureCacheStorage =  SaveSecureCacheStorageSpy();
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);
    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });
}
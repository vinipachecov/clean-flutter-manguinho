import 'package:clean_flutter_manguinho/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import '../../mocks/secure_cache_storage_spy.dart';

void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late AccountEntity account;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: secureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(() => secureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw an UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockSaveError();

    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}

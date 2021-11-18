import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/data/usecases/load_current_account/load_current_account.dart';

import '../../mocks/secure_cache_storage_spy.dart';

void main() {
  late SecureCacheStorageSpy secureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: secureCacheStorage);
    token = faker.guid.guid();
    secureCacheStorage.mockFetch(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => secureCacheStorage.fetch('token'));
  });
  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should thow Unexpected error if FetchSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockFetchError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should thow Unexpected error if FetchSecureCacheStorage returns null',
      () async {
    secureCacheStorage.mockFetch(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

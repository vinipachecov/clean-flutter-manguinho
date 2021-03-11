import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:clean_flutter_manguinho/domain/entities/account_entity.dart';
import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/data/usecases/load_current_account/load_current_account.dart';



class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {

  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(DomainError.unexpected);
  }
  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });
   test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should thow Unexpected error if FetchSecureCacheStorage throws', () async {
    mockFetchSecureError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}


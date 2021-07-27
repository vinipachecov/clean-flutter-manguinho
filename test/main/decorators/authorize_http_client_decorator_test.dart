import 'package:clean_flutter_manguinho/data/cache/fetch_secure_cache_storage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request() async {
    fetchSecureCacheStorage.fetchSecure('token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  AuthorizeHttpClientDecorator sut;

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorageSpy);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
  });
}

import 'package:clean_flutter_manguinho/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<void> request({
    String url,
    String method,
    Map body,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = {'x-access-token': token};
    decoratee.request(
        url: url, method: method, body: body, headers: authorizedHeaders);
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;
  HttpClientSpy httpClientSpy;
  String token;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheStorageSpy.fetchSecure(any))
        .thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    httpClientSpy = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
        decoratee: httpClientSpy);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorageSpy.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);

    verify(httpClientSpy.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);
  });
}

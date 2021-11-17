import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/main/decorators/decorators.dart';
import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock
    implements DeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  late DeleteSecureCacheStorageSpy deleteSecureCacheStorageSpy;
  late AuthorizeHttpClientDecorator sut;
  late String url;
  late String method;
  late Map body;
  late HttpClientSpy httpClientSpy;
  late String token;
  late String httpResponse;

  When mockTokenCall() {
    return when(() => fetchSecureCacheStorageSpy.fetch(any()));
  }

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  When mockHttpResponseCall() {
    return when(() => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
        headers: any(named: 'headers')));
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(error) {
    mockHttpResponseCall().thenThrow(error);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    deleteSecureCacheStorageSpy = DeleteSecureCacheStorageSpy();
    httpClientSpy = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
        deleteSecureCacheStorage: deleteSecureCacheStorageSpy,
        decoratee: httpClientSpy);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => fetchSecureCacheStorageSpy.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});

    verify(() => httpClientSpy.request(
            url: url,
            method: method,
            body: body,
            headers: {'x-access-token': token, 'any_header': 'any_value'}))
        .called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    mockTokenError();
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => deleteSecureCacheStorageSpy.delete('token')).called(1);
  });

  test('Should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbiddenError', () async {
    mockHttpResponseError(HttpError.forbidden);
    final future = sut.request(url: url, method: method, body: body);

    /**
     * untilCalled is a helper method from Mockito to ensure that our test
     * gives enough time for an async method to run. 
     */
    await untilCalled(() => deleteSecureCacheStorageSpy.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => deleteSecureCacheStorageSpy.delete('token')).called(1);
  });
}

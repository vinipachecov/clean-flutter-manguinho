import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/main/decorators/decorators.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';

import '../../data/mocks/http_client_spy.dart';
import '../../data/mocks/secure_cache_storage_spy.dart';

void main() {
  late SecureCacheStorageSpy secureCacheStorage;
  late AuthorizeHttpClientDecorator sut;
  late String url;
  late String method;
  late Map body;
  late HttpClientSpy httpClientSpy;
  late String token;
  late String httpResponse;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    httpClientSpy = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: secureCacheStorage,
        deleteSecureCacheStorage: secureCacheStorage,
        decoratee: httpClientSpy);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    secureCacheStorage.mockFetch(token);
    httpClientSpy.mockRequest(httpResponse);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => secureCacheStorage.fetch('token')).called(1);
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
    secureCacheStorage.mockFetchError();
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });

  test('Should rethrow if decoratee throws', () async {
    httpClientSpy.mockRequestError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbiddenError', () async {
    httpClientSpy.mockRequestError(HttpError.forbidden);
    final future = sut.request(url: url, method: method, body: body);

    /**
     * untilCalled is a helper method from Mockito to ensure that our test
     * gives enough time for an async method to run. 
     */
    await untilCalled(() => secureCacheStorage.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });
}

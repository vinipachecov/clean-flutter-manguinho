



import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/data/usecases/authentication/remote_authentication.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';


class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;
  Map mockValidData() => {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name()
    };

  PostExpectation mockRequest() =>    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockhttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'email': params.email,
      'password': params.secret
    }));
  });

   test('Should throw UnexpectedError if HttpClient returns 400', () async {
     mockhttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
     mockhttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
     mockhttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async {
     mockhttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
     mockHttpData({ 'invalid_key': 'invalid_value' });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
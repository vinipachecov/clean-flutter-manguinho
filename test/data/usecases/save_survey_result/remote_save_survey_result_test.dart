import 'dart:io';
import 'package:clean_flutter_manguinho/data/http/http_error.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/domain_error.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteSaveSurveyResult sut;
  String answer;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    answer = faker.lorem.sentence();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });
  test('Should call HttpClient with correct values', () async {
    await sut.save(answer);

    verify(
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });
}

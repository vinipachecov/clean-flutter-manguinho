import 'dart:io';

import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/data/models/models.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse.map<SurveyEntity>((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;

  PostExpectation mockRequest() =>
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        }
      ];

    void mockHttpData(List<Map> data) {
      list = data;
      mockRequest().thenAnswer((_) async => data);
    }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      )
    ]);
  });
}

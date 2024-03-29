import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/data/http/http_error.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {
  When mockRequestCall() => when(() => this.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body'),
      headers: any(named: 'headers')));

  void mockRequest(dynamic data) =>
      this.mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) =>
      this.mockRequestCall().thenThrow(error);
}

import 'dart:convert';
import 'package:clean_flutter_manguinho/data/http/http_client.dart';

import 'package:meta/meta.dart';
import 'package:http/http.dart';
import '../../data/http/http_error.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request(
      {@required String url,
      @required String method,
      Map body,
      Map headers}) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(
          {'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    try {
      if (method == 'post') {
        response = await client
            .post(url, headers: defaultHeaders, body: jsonBody)
            .timeout(Duration(seconds: 5));
      } else if (method == 'get') {
        response = await client
            .get(url, headers: defaultHeaders)
            .timeout(Duration(seconds: 5));
      } else if (method == 'put') {
        response = await client
            .put(url, headers: defaultHeaders, body: jsonBody)
            .timeout(Duration(seconds: 5));
      }
    } catch (e) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}

import 'dart:convert';
import '../../data/http/http_error.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
       'content-type': 'application/json',
        'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw HttpError.badRequest;
    }
  }
}
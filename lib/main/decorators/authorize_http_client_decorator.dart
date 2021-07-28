import 'package:clean_flutter_manguinho/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<dynamic> request({
    String url,
    String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError {
      rethrow;
    } catch (e) {
      throw HttpError.forbidden;
    }
  }
}

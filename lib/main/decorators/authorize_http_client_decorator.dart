import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/http/http.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage,
      @required this.deleteSecureCacheStorage,
      @required this.decoratee});

  Future<dynamic> request({
    String url,
    String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      final response = await decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
      return response;
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      }
      await deleteSecureCacheStorage.delete('token');
      throw HttpError.forbidden;
    }
  }
}

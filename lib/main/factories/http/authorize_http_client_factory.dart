import 'package:clean_flutter_manguinho/data/http/http_client.dart';
import 'package:clean_flutter_manguinho/main/decorators/decorators.dart';
import 'package:clean_flutter_manguinho/main/factories/cache/cache.dart';
import 'package:clean_flutter_manguinho/main/factories/http/http.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeLocalStorageAdapter());

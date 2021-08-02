import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/cache/cache.dart';

class SecureStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  FlutterSecureStorage secureStorage;

  SecureStorageAdapter({this.secureStorage});

  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await this.secureStorage.write(key: key, value: value);
  }

  Future<String> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }
}

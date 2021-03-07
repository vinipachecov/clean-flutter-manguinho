
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  FlutterSecureStorage secureStorage;

  LocalStorageAdapter({this.secureStorage});

  Future<void> saveSecure({@required String key, @required String value}) async {
    await this.secureStorage.write(key: key, value: value);
  }
}

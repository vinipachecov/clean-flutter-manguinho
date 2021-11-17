import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter implements CacheStorage {
  LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
  }

  Future<dynamic> fetch(String key) async {
    await localStorage.ready;
    final data = await localStorage.getItem(key);
    return data;
  }
}

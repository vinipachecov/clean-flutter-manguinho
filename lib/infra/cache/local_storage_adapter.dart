import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

  Future<dynamic> fetch(String key) async {
    final data = await localStorage.getItem(key);
    return data;
  }
}

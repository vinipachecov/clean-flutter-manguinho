import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  LocalStorage localStorage;

  LocalStorageAdapter({this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}

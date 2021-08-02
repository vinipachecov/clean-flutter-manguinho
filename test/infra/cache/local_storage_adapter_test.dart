import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

class LocalStorageAdapter {
  LocalStorage localStorage;

  LocalStorageAdapter({this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) {
    localStorage.deleteItem(key);
    localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  String key;
  String value;
  LocalStorage localStorage;
  LocalStorageAdapter sut;
  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });
  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });
}

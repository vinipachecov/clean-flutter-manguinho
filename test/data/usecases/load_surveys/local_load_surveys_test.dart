import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;
  LocalLoadSurveys({@required this.fetchCacheStorage});
  Future<void> load() async {
    await fetchCacheStorage.fetch('surveys');
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

void main() {
  FetchCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadSurveys sut;
  setUp(() {
    fetchSecureCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchSecureCacheStorage);
  });
  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetch('surveys')).called(1);
  });
}

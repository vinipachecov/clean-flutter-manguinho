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

class FetchSecureCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

void main() {
  test('Should call FetchCacheStorage with correct key', () async {
    final fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    final sut = LocalLoadSurveys(fetchCacheStorage: fetchSecureCacheStorageSpy);

    await sut.load();

    verify(fetchSecureCacheStorageSpy.fetch('surveys')).called(1);
  });
}

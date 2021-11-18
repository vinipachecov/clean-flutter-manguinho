import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/cache/delete_secure_cache_storage.dart';
import 'package:clean_flutter_manguinho/data/cache/fetch_secure_cache_storage.dart';
import 'package:mocktail/mocktail.dart';

class SecureCacheStorageSpy extends Mock
    implements
        FetchSecureCacheStorage,
        DeleteSecureCacheStorage,
        SaveSecureCacheStorage {
  SecureCacheStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockFetchCall() => when(() => this.fetch(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow((_) async => Exception());

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() =>
      mockDeleteCall().thenThrow((_) async => Exception());

  When mockSaveCall() =>
      when(() => save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow((_) async => Exception());
}

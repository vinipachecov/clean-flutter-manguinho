import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await this.fetchSecureCacheStorage.fetch('token');
      if (token == null) throw Error();
      return AccountEntity(token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

import 'package:clean_flutter_manguinho/data/cache/cache.dart';
import 'package:clean_flutter_manguinho/data/models/models.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;
  LocalLoadSurveys({@required this.fetchCacheStorage});
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await fetchCacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return data
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

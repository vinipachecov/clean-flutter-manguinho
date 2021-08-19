import 'package:clean_flutter_manguinho/domain/entities/survey_result_entity.dart';
import 'package:meta/meta.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';

import 'package:clean_flutter_manguinho/data/http/http.dart';
import 'package:clean_flutter_manguinho/data/models/models.dart';

class RemoteSaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  Future<void> save(String answer) async {
    await httpClient.request(url: url, method: 'put', body: {'answer': answer});
  }
}

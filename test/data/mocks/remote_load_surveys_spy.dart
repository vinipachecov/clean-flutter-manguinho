import 'package:mocktail/mocktail.dart';
import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {
  When mockLoadSurveysCall() => when(() => this.load());

  void mockLoadSurveys(List<SurveyEntity> remoteSurveys) {
    mockLoadSurveysCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockLoadSurveysError(DomainError error) {
    mockLoadSurveysCall().thenThrow(error);
  }
}

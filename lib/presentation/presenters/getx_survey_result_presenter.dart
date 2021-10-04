import 'package:clean_flutter_manguinho/domain/entities/entities.dart';
import 'package:clean_flutter_manguinho/presentation/mixins/mixins.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/domain/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/presentation/helpers/helpers.dart';

class GetxLoadSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxLoadSurveyResultPresenter(
      {@required this.loadSurveyResult,
      @required this.saveSurveyResult,
      this.surveyId});

  Future<void> loadData() async {
    await showResult(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void> save({String answer}) async {
    await showResult(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResult(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final saveResult = await action();
      // Map de SurveyEntity para SurveyViewModel
      _surveyResult.subject.add(saveResult.toViewModel());
      isLoading = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}

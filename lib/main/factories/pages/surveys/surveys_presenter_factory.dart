import 'package:clean_flutter_manguinho/main/factories/usecases/usecases.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SurveysPresenter makeGetxSurveyPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}


import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount()
  );
}
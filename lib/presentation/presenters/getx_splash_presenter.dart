import 'package:clean_flutter_manguinho/presentation/mixins/mixins.dart';
import 'package:clean_flutter_manguinho/domain/usecases/usecases.dart';
import 'package:clean_flutter_manguinho/ui/pages/splash/splash.dart';
import 'package:get/get.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  Future<void> checkAccount({int durationInSecods = 2}) async {
    await Future.delayed(Duration(seconds: durationInSecods));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account?.token == null ? '/login' : '/surveys';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}

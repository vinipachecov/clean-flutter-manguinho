import 'package:get/get.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';

mixin UIErrorManager on GetxController {
  final _mainError = Rx<UIError>();
  Stream<UIError> get mainErrorStream => _mainError.stream;

  set mainError(UIError value) => _mainError.value = value;
}

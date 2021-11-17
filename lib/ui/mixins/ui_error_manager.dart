import 'package:flutter/material.dart';
import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((UIError? error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}

import 'package:get/get.dart';
import '../../../../ui/pages/pages.dart';
import '../../../factories/factories.dart';
import 'package:flutter/material.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(
      makeGetxSurveyResultPresenter(Get.parameters['survey_id']));
}

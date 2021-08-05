import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/components/survey_item.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';
import 'package:flutter/material.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;
  const SurveyItems(this.viewModels);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
          options: CarouselOptions(enlargeCenterPage: true, aspectRatio: 1),
          items: this
              .viewModels
              .map((viewModel) => SurveyItem(viewModel))
              .toList()),
    );
  }
}

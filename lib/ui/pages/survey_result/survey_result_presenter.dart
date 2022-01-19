import './survey_result.dart';
import 'package:flutter/material.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel?> get surveyResultStream;
  Stream<bool> get isSessionExpiredStream;
  Future<void> loadData();
  Future<void> save({required String answer});
}

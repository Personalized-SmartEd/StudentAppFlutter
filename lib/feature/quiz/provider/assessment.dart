import 'package:flutter/material.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';

class AssessmentProvider extends ChangeNotifier {
  Assessment _assessment = Assessment(
    questions: [],
  );

  Assessment get assessment => _assessment;

  void setAssessment(String assessment) {
    _assessment = Assessment.fromJson(assessment);
    notifyListeners();
  }

  void setAssessmentFromModel(Assessment assessment) {
    _assessment = assessment;
    notifyListeners();
  }
}

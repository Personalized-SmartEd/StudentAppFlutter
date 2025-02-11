import 'package:flutter/material.dart';
import 'package:smarted/feature/quiz/model/subjectQuiz.dart';

class SubjectquizProvider extends ChangeNotifier {
  Subjectquiz _subjectquiz = Subjectquiz(
    questions: [],
  );

  Subjectquiz get subjectquiz => _subjectquiz;

  void setSubjectquiz(String subjectquiz) {
    _subjectquiz = Subjectquiz.fromJson(subjectquiz);
    notifyListeners();
  }

  void setSubjectquizFromModel(Subjectquiz subjectquiz) {
    _subjectquiz = subjectquiz;
    notifyListeners();
  }
}

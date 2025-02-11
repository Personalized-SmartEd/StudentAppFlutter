// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smarted/feature/quiz/model/question.dart';

class Subjectquiz {
  List<Question> questions;

  Subjectquiz({
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Subjectquiz.fromMap(Map<String, dynamic> map) {
    return Subjectquiz(
      questions: List<Question>.from(
        (map['questions'] as List).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Subjectquiz.fromJson(String source) =>
      Subjectquiz.fromMap(json.decode(source) as Map<String, dynamic>);
}

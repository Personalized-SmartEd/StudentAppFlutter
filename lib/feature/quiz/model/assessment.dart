// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smarted/feature/quiz/model/question.dart';

class Assessment {
  List<Question> questions;

  Assessment({
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      questions: List<Question>.from(
        (map['questions'] as List).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Assessment.fromJson(String source) =>
      Assessment.fromMap(json.decode(source) as Map<String, dynamic>);
}

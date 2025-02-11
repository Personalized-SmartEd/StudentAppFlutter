// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Question {
  List<String>? options;
  int? qid;
  String? question;
  int? correct_option;
  String? answer;
  String? explanation;
  Question(
      {this.options,
      this.qid,
      this.question,
      this.answer,
      this.correct_option,
      this.explanation});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'options': options,
      'qid': qid,
      'question': question,
      'correct_option': correct_option,
      'answer': answer,
      'explanation': explanation
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      options: map['options'] != null
          ? List<String>.from(map['options'].map((x) => x.toString()))
          : null,
      qid: map['qid'] as int?,
      question: map['question'] as String?,
      correct_option: map['correct_option'] as int?,
      answer: map['answer'] as String?,
      explanation: map['explanation'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Question {
  List<String>? options;
  int? qid;
  String? question;

  Question({this.options, this.qid, this.question});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'options': options,
      'qid': qid,
      'question': question,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      options: map['options'] != null
          ? List<String>.from(map['options'].map((x) => x.toString()))
          : null,
      qid: map['qid'] as int?,
      question: map['question'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);
}

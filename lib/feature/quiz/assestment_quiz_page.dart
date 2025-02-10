import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';
import 'package:smarted/feature/quiz/provider/assessment.dart';
import 'package:smarted/feature/quiz/quiz_page.dart';
import 'package:smarted/widgets/button.dart';

class AssestmentQuiz extends StatefulWidget {
  const AssestmentQuiz({super.key});

  @override
  State<AssestmentQuiz> createState() => _AssestmentQuizState();
}

class _AssestmentQuizState extends State<AssestmentQuiz> {
  @override
  void initState() {
    print("getting assestment");
    AssessmentServices.getAssessment(context);
    super.initState();
  }

  void _startQuiz() {
    // Navigator.pushNamed(context, '/quiz');
    Assessment assessment =
        Provider.of<AssessmentProvider>(context, listen: false).assessment;

    // for (var question in assessment.questions) {
    //   print(question.question);
    // }
    if (assessment.questions.isEmpty) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizPage(assessment: assessment);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Assessment Quiz"),
        ),
        body: Center(
          child: Button(onPressed: _startQuiz, text: "Start Quiz"),
        ));
  }
}

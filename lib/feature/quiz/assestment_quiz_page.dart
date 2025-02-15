import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';
import 'package:smarted/feature/quiz/provider/assessment.dart';
import 'package:smarted/feature/quiz/quiz_page.dart';
import 'package:smarted/widgets/button.dart';

class AssessmentQuiz extends StatefulWidget {
  const AssessmentQuiz({super.key});

  @override
  State<AssessmentQuiz> createState() => _AssessmentQuizState();
}

class _AssessmentQuizState extends State<AssessmentQuiz> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssessment();
  }

  void _fetchAssessment() async {
    await AssessmentServices.getAssessment(context);
    setState(() {
      _isLoading = false;
    });
  }

  void _startQuiz() {
    Assessment assessment =
        Provider.of<AssessmentProvider>(context, listen: false).assessment;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPage(assessment: assessment)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Understanding Your Learning Style",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Take this short quiz to help us tailor the learning experience based on your strengths.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _isLoading
                ? CircularProgressIndicator()
                : Button(onPressed: _startQuiz, text: "Start Quiz"),
          ],
        ),
      ),
    );
  }
}

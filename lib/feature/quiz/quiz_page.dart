import 'package:flutter/material.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';
import 'package:smarted/feature/quiz/model/question.dart';
import 'package:smarted/feature/quiz/model/subjectQuiz.dart';
import 'package:smarted/feature/quiz/subject_quiz_services.dart';

class QuizPage extends StatefulWidget {
  final Assessment? assessment;
  final Subjectquiz? subjectQuiz;
  final String? subject;
  const QuizPage({super.key, this.assessment, this.subjectQuiz, this.subject})
      : assert(assessment != null || subjectQuiz != null,
            'One of assessment or subjectQuiz must be provided.');

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  Map<int, String> selectedAnswers = {};
  late List<int> ans;
  late List<Question> questions;
  bool showCorrectAnswer = false;
  bool sub = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    questions = widget.assessment?.questions ?? widget.subjectQuiz!.questions;
    ans = List<int>.filled(questions.length, 1, growable: false);
  }

  void nextPage() {
    if (_currentIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
        showCorrectAnswer = false;
      });
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex--;
        showCorrectAnswer = false;
      });
    }
  }

  void checkAnswer(int index) {
    setState(() {
      showCorrectAnswer = true;
    });
  }

  void _submitSubjectQuiz() {
    print("subb");
    if (widget.subjectQuiz == null) print("subbqq null");
    if (widget.subject == null) print("subb null");
    if (widget.subjectQuiz != null && widget.subject != null) {
      int correctAnswers = 0;
      widget.subjectQuiz!.questions.asMap().forEach((index, question) {
        if (question.answer == question.options![ans[index]]) {
          correctAnswers++;
        }
      });

      print(correctAnswers);

      SubjectQuizServices.submitSubjectQuiz(
          ans: correctAnswers, subject: widget.subject!, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: PageView.builder(
        controller: _pageController,
        itemCount: questions.length,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe navigation
        itemBuilder: (context, index) {
          return buildQuestionPage(questions[index], index);
        },
      ),
    );
  }

  Widget buildQuestionPage(Question question, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${index + 1}/${questions.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            question.question ?? "No question",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            children: question.options!.map((option) {
              bool isCorrect = showCorrectAnswer && option == question.answer;
              return ListTile(
                title: Text(option,
                    style: TextStyle(color: isCorrect ? Colors.green : null)),
                leading: Radio<String>(
                  value: option,
                  groupValue: selectedAnswers[index],
                  onChanged: (value) {
                    setState(() {
                      selectedAnswers[index] = value!;
                      ans[index] = question.options!.indexOf(value!);
                    });
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (index > 0)
                ElevatedButton(
                  onPressed:
                      selectedAnswers.containsKey(index) ? previousPage : null,
                  child: const Text("Previous"),
                ),
              if (index < questions.length - 1)
                ElevatedButton(
                  onPressed:
                      selectedAnswers.containsKey(index) ? nextPage : null,
                  child: const Text("Next"),
                ),
              if (index == questions.length - 1)
                ElevatedButton(
                  onPressed: () {
                    if (widget.assessment != null) {
                      AssessmentServices.sumbmitAssessment(context, ans);
                    } else if (widget.subjectQuiz != null) {
                      // Add logic to submit subject quiz answers
                      _submitSubjectQuiz();
                    }
                    print("User Answers: $selectedAnswers");
                    print("User Answers: $ans");
                  },
                  child: const Text("Submit"),
                ),
              if (widget.subjectQuiz != null)
                ElevatedButton(
                  onPressed: selectedAnswers.containsKey(index)
                      ? () => checkAnswer(index)
                      : null,
                  child: const Text("Check Answer"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

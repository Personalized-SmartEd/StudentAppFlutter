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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    questions = widget.assessment?.questions ?? widget.subjectQuiz!.questions;
    ans = List<int>.filled(questions.length, -1, growable: false);
  }

  void nextPage() {
    if (selectedAnswers.containsKey(_currentIndex)) {
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
    } else {
      _showSelectAnswerDialog();
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
    if (selectedAnswers.containsKey(index)) {
      setState(() {
        showCorrectAnswer = true;
      });
    } else {
      _showSelectAnswerDialog();
    }
  }

  void submitQuiz() {
    if (selectedAnswers.length == questions.length) {
      if (widget.assessment != null) {
        AssessmentServices.sumbmitAssessment(context, ans);
      } else if (widget.subjectQuiz != null) {
        SubjectQuizServices.submitSubjectQuiz(
            ans: ans.where((a) => a != -1).length,
            subject: widget.subject!,
            context: context);
      }
    } else {
      _showSelectAnswerDialog();
    }
  }

  void _showSelectAnswerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select an Answer"),
        content: const Text("Please select an answer before proceeding."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${_currentIndex + 1}/${questions.length}"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: questions.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return buildQuestionPage(questions[index], index);
        },
      ),
    );
  }

  Widget buildQuestionPage(Question question, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      question.question ?? "No question",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: question.options!.map((option) {
                        bool isSelected = selectedAnswers[index] == option;
                        bool isCorrect =
                            showCorrectAnswer && option == question.answer;
                        bool isWrong = showCorrectAnswer &&
                            isSelected &&
                            option != question.answer;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAnswers[index] = option;
                              ans[index] = question.options!.indexOf(option);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green
                                  : isWrong
                                      ? Colors.red
                                      : isSelected
                                          ? Colors.deepPurpleAccent
                                          : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.deepPurple),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected || isCorrect || isWrong
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                if (isCorrect)
                                  const Icon(Icons.check_circle,
                                      color: Colors.green),
                                if (isWrong)
                                  const Icon(Icons.cancel, color: Colors.red),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (index < questions.length - 1)
                  ElevatedButton(onPressed: nextPage, child: const Text("Next")),
                if (widget.subjectQuiz != null)
                  ElevatedButton(
                      onPressed: () => checkAnswer(index),
                      child: const Text("Show Correct Answer")),
                if (index == questions.length - 1)
                  ElevatedButton(
                      onPressed: submitQuiz, child: const Text("Submit")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

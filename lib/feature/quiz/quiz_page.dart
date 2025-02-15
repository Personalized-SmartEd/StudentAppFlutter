import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            // Question Card with a futuristic look
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              shadowColor: Colors.deepPurpleAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Question ${index + 1}",
                      style: GoogleFonts.pressStart2p(
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question.question ?? "No question",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Options with a gaming look
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: isCorrect
                                  ? LinearGradient(
                                      colors: [Colors.green, Colors.lightGreen])
                                  : isWrong
                                      ? LinearGradient(
                                          colors: [Colors.red, Colors.orange])
                                      : isSelected
                                          ? LinearGradient(colors: [
                                              Colors.purpleAccent,
                                              Colors.deepPurple
                                            ])
                                          : LinearGradient(colors: [
                                              Colors.grey.shade300,
                                              Colors.white
                                            ]),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.deepPurple, width: 2),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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

            // Custom Progress Indicator with a gaming touch
            Stack(
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                ),
                Positioned(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      height: 20,
                      width: constraints.maxWidth *
                          ((_currentIndex + 1) / questions.length),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [Colors.deepPurple, Colors.blueAccent]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons with a neon glow effect
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (index < questions.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.deepPurpleAccent,
                      elevation: 6,
                    ),
                    onPressed: nextPage,
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                if (widget.subjectQuiz != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.blueAccent,
                      elevation: 6,
                    ),
                    onPressed: () => checkAnswer(index),
                    child: const Text(
                      "Show Answer",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                if (index == questions.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.greenAccent,
                      elevation: 6,
                    ),
                    onPressed: submitQuiz,
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

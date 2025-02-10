import 'package:flutter/material.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';
import 'package:smarted/feature/quiz/model/question.dart';

class QuizPage extends StatefulWidget {
  final Assessment assessment;

  const QuizPage({super.key, required this.assessment});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  Map<int, String> selectedAnswers = {};
  late List<int> ans;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    ans = List<int>.filled(widget.assessment.questions.length, 1,
        growable: false);
  }

  void nextPage() {
    if (_currentIndex < widget.assessment.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.assessment.questions.length,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe navigation
        itemBuilder: (context, index) {
          return buildQuestionPage(widget.assessment.questions[index], index);
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
            "Question ${index + 1}/${widget.assessment.questions.length}",
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
              return ListTile(
                title: Text(option),
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
                  onPressed: previousPage,
                  child: const Text("Previous"),
                ),
              if (index < widget.assessment.questions.length - 1)
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text("Next"),
                ),
              if (index == widget.assessment.questions.length - 1)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Submit answers logic
                    AssessmentServices.sumbmitAssessment(context, ans);
                    print("User Answers: $selectedAnswers");
                    print("User Answers: $ans");
                  },
                  child: const Text("Submit"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

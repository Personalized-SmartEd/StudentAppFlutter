import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/quiz/model/subjectQuiz.dart';
import 'package:smarted/feature/quiz/provider/subjectQuiz.dart';
import 'package:smarted/feature/quiz/quiz_page.dart';
import 'package:smarted/feature/quiz/subject_quiz_services.dart';
import 'package:smarted/widgets/button.dart';
import 'package:smarted/widgets/button/primary_button.dart';
import 'package:smarted/widgets/button/secondary_button.dart';

class SubjectQuizPage extends StatefulWidget {
  @override
  _SubjectQuizPageState createState() => _SubjectQuizPageState();
}

class _SubjectQuizPageState extends State<SubjectQuizPage> {
  final _formKey = GlobalKey<FormState>();

  String subject = 'math';
  String chapter = '';
  String topicDescription = '';
  int quizDifficulty = 6;
  int quizDuration = 12;
  int numberOfQuestions = 2;
  bool dis = false;
  List<String> subjects = [
    'math',
    'science',
    'english',
    'social-science',
    'hindi'
  ]; // Example subjects

  final TextEditingController chapterController = TextEditingController();
  final TextEditingController topicDescriptionController =
      TextEditingController();
  final TextEditingController quizDifficultyController =
      TextEditingController(text: '6');
  final TextEditingController quizDurationController =
      TextEditingController(text: '12');
  final TextEditingController numberOfQuestionsController =
      TextEditingController(text: '2');

  void _submit() async {
    setState(() {
      dis = true;
    });
    await SubjectQuizServices.createQuiz(
        context: context,
        chapter: chapter,
        subject: subject,
        topicDescription: topicDescription,
        quizDifficulty: quizDifficulty.toString(),
        quizDuration: quizDuration.toString(),
        numberOfQuestions: numberOfQuestions.toString());
    setState(() {
      dis = false;
    });
  }

  void _startQuiz() {
    // Navigator.pushNamed(context, '/quiz');

    // for (var question in assessment.questions) {
    //   print(question.question);
    // }
    Subjectquiz subjectquiz =
        Provider.of<SubjectquizProvider>(context, listen: false).subjectquiz;
    if (subjectquiz.questions.isEmpty) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizPage(
        subjectQuiz: subjectquiz,
        subject: subject,
      );
    }));
  }

  @override
  void dispose() {
    chapterController.dispose();
    topicDescriptionController.dispose();
    quizDifficultyController.dispose();
    quizDurationController.dispose();
    numberOfQuestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Subject'),
                  value: subjects[0],
                  items: subjects.map((String subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      subject = newValue!;
                    });
                  },
                  onSaved: (value) {
                    subject = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: chapterController,
                  decoration: InputDecoration(labelText: 'Chapter'),
                  onSaved: (value) {
                    chapter = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: topicDescriptionController,
                  decoration: InputDecoration(labelText: 'Topic Description'),
                  onSaved: (value) {
                    topicDescription = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: quizDifficultyController,
                  decoration:
                      InputDecoration(labelText: 'Quiz Difficulty (1-10)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    quizDifficulty = int.parse(value!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: quizDurationController,
                  decoration:
                      InputDecoration(labelText: 'Quiz Duration (minutes)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    quizDuration = int.parse(value!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: numberOfQuestionsController,
                  decoration: InputDecoration(labelText: 'Number of Questions'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    numberOfQuestions = int.parse(value!);
                  },
                ),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onPressed: _submit,
                label: 'Create Quiz',
                isDisabled: dis,
              ),
              SizedBox(height: 20),
              if (dis) CircularProgressIndicator(),
              SecondaryButton(
                onPressed: _startQuiz,
                label: 'Start Quiz',
                isDisabled: dis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

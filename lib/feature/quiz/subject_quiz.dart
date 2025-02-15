import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/quiz/model/subjectQuiz.dart';
import 'package:smarted/feature/quiz/provider/subjectQuiz.dart';
import 'package:smarted/feature/quiz/quiz_page.dart';
import 'package:smarted/feature/quiz/subject_quiz_services.dart';
import 'package:smarted/widgets/button/primary_button.dart';

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
  bool isLoading = false;

  final TextEditingController chapterController = TextEditingController();
  final TextEditingController topicDescriptionController =
      TextEditingController();
  final TextEditingController quizDifficultyController =
      TextEditingController();
  final TextEditingController quizDurationController = TextEditingController();
  final TextEditingController numberOfQuestionsController =
      TextEditingController();

  List<String> subjects = [
    'math',
    'science',
    'english',
    'social-science',
    'hindi'
  ];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      await SubjectQuizServices.createQuiz(
        context: context,
        chapter: chapter,
        subject: subject,
        topicDescription: topicDescription,
        quizDifficulty: quizDifficultyController.text,
        quizDuration: quizDifficultyController.text,
        numberOfQuestions: numberOfQuestionsController.text,
      );

      setState(() => isLoading = false);
      _startQuiz();
    }
  }

  void _startQuiz() {
    Subjectquiz subjectquiz =
        Provider.of<SubjectquizProvider>(context, listen: false).subjectquiz;
    if (subjectquiz.questions.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizPage(subjectQuiz: subjectquiz, subject: subject),
      ),
    );
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Quiz', style: theme.textTheme.bodyLarge),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildDropdown(),
              SizedBox(height: 12),
              _buildTextField('Chapter', chapterController),
              _buildTextField('Topic Description', topicDescriptionController),
              _buildTextField(
                  'Quiz Difficulty (1-10)', quizDifficultyController,
                  isNumber: true),
              _buildTextField('Quiz Duration (minutes)', quizDurationController,
                  isNumber: true),
              _buildTextField(
                  'Number of Questions', numberOfQuestionsController,
                  isNumber: true),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      onPressed: _submit,
                      label: 'Create Quiz',
                      isDisabled: isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primaryColor, width: 1.5),
          color: theme.cardColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: subject,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
            // style: theme.textTheme.bodyText1,
            dropdownColor: theme.cardColor,
            items: subjects.map((String subject) {
              return DropdownMenuItem<String>(
                value: subject,
                child: Text(subject),
              );
            }).toList(),
            onChanged: (newValue) => setState(() => subject = newValue!),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}

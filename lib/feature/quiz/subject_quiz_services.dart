import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/feature/quiz/model/subjectQuiz.dart';
import 'package:smarted/feature/quiz/provider/subjectQuiz.dart';
import 'package:smarted/widgets/snackbar.dart';

class SubjectQuizServices {
  static Future<void> createQuiz({
    required BuildContext context,
    required String subject,
    required String chapter,
    required String topicDescription,
    required String quizDifficulty,
    required String quizDuration,
    required String numberOfQuestions,
  }) async {
    var subjectQuizProvider =
        Provider.of<SubjectquizProvider>(context, listen: false);
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print(userProvider.user.Token);
      print(subject);
      print("getting quizs");
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/quiz'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "subject_info": {
            "subject": subject,
            "chapter": chapter,
            "topic_description": topicDescription
          },
          "quiz_info": {
            "quiz_difficulty_from_1_to_10": int.parse(quizDifficulty),
            "quiz_duration_minutes": int.parse(quizDuration),
            "number_of_questions": int.parse(numberOfQuestions)
          }
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          print(res.body);
          Subjectquiz subjectquiz = Subjectquiz.fromJson(res.body);
          subjectQuizProvider.setSubjectquizFromModel(
            subjectquiz,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, " error ?? ${e.toString()}");
    }
  }

  static Future<void> submitSubjectQuiz({
    required BuildContext context,
    required int ans,
    required String subject,
  }) async {
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print(userProvider.user.Token);
      print("submitting quizs");
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/assessment/dynamic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "subject": subject,
          "scores": [ans]
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          print(res.body);
          showDialog(
            context: context,
            barrierDismissible:
                true, // Allows dismissing the dialog by tapping outside
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false,
                  );
                  return false;
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    "Quiz Submission Result",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Subject: math",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Performance Level: beginner",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Average Score: 0.0",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Trend: stable",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, " error ?? ${e.toString()}");
    }
  }
}

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
import 'package:smarted/feature/quiz/quizresult.dart';
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
      print(int.parse(numberOfQuestions));
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
      showSnackBar(context,
          " Check your Internet connection / Its probably your fault ");
    }
  }

  static Future<void> submitSubjectQuiz({
    required BuildContext context,
    required int ans,
    required String subject,
  }) async {
    print("ans is");
    print(ans);
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print(userProvider.user.Token);
      print("submitting quizs");
      List<int> currentperformance = [
        ...userProvider.user.PastPerformance,
        ans
      ];
      print(currentperformance);
      userProvider.updateUser(PastPerformance: currentperformance);
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/assessment/dynamic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "subject": subject,
          "scores": currentperformance
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          print(res.body);
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          // Extracting values from response
          String subjectName = responseData["subject"] ?? "N/A";
          String performanceLevel =
              responseData["performance_level"] ?? "Unknown";
          double averageScore =
              (responseData["average_score"] ?? 0.0).toDouble();
          String trend = responseData["trend"] ?? "Unknown";

          showQuizResultDialog(
            context,
            responseData["subject"] ?? "N/A",
            responseData["performance_level"] ?? "Unknown",
            (responseData["average_score"] ?? 0.0).toDouble(),
            responseData["trend"] ?? "Unknown",
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, "Error: ${e.toString()}");
    }
  }
}

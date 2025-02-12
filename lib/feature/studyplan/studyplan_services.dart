import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';
import 'package:smarted/widgets/snackbar.dart';

class StudyPlanServices {
  static Future<void> getStudyPlan({
    required BuildContext context,
    required String? learningStyle,
    required List<String> weakAreas,
    required int availableHours,
  }) async {
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/recommend/generate_study_plan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "learning_style": "visual",
          "current_level": "beginner",
          "weak_areas": ["english", "maths"],
          "performance_history": [1],
          "preferred_pace": "slow",
          "available_hours": 1
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final studyplan = jsonDecode(res.body);
          print(studyplan['exercise_plan']);
          print(studyplan);

          navigator.push(
            MaterialPageRoute(
                builder: (context) => StudyPlan(studyplan: studyplan)),
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, " error ?? ${e.toString()}");
    }
  }
}

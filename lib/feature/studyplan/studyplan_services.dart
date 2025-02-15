import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';
import 'package:smarted/feature/studyplan/studyplanprovider.dart';
import 'package:smarted/widgets/snackbar.dart';

class StudyPlanServices {
  static Future<dynamic> getStudyPlan({
    required BuildContext context,
    required List<String> weakAreas,
  }) async {
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var studyplanProvider =
          Provider.of<StudyPlanProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/recommend/generate_study_plan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "learning_style": userProvider.user.LearningStyle,
          "current_level": userProvider.user.PerformanceLvl,
          "weak_areas": weakAreas,
          "performance_history": userProvider.user.PastPerformance,
          "preferred_pace": userProvider.user.Pace,
          "available_hours": 1
        }),
      );
      dynamic studypln = "";

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final studyplan = jsonDecode(res.body);
          print(studyplan['exercise_plan']);
          print(studyplan);
          studypln = studyplan;
          studyplanProvider.setStudyplan(studyplan);
          navigator.push(
            MaterialPageRoute(
                builder: (context) => StudyPlan(studyplan: studyplan)),
          );
        },
      );
      return studypln;
    } catch (e) {
      print(e.toString());
      showSnackBar(context,
          " Check your Internet connection / Its probably your fault ");
    }
  }
}

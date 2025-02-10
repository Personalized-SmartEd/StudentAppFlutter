import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/feature/quiz/model/assessment.dart';
import 'package:smarted/feature/quiz/provider/assessment.dart';

class AssessmentServices {
  static void getAssessment(BuildContext context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    var assessmentProvider =
        Provider.of<AssessmentProvider>(context, listen: false);
    try {
      print("Getting quiz");
      http.Response res = await http.get(
        Uri.parse('${Endpoints.baseURL}/assessment/static'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': user.Token
        },
      );
      print("Gettin");

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("Got quiz");
            print(res.body);
            // Assessment questions = Assessment.fromJson(jsonDecode(res.body));
            Assessment assessment = Assessment.fromJson(res.body);
            assessmentProvider.setAssessmentFromModel(assessment);
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static void sumbmitAssessment(BuildContext context, List<int> ans) async {
    final navigator = Navigator.of(context);
    User user = Provider.of<UserProvider>(context, listen: false).user;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    print(user.Token);
    try {
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/assessment/static'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': user.Token
        },
        body: jsonEncode(<String, dynamic>{
          'responses': ans,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("Got ress");
            print(res.body);
            String style = jsonDecode(res.body)['style'];
            print(style);
            userProvider.updateUser(
              LearningStyle: style,
            );
            print(user);
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false,
            );
            // Assessment questions = Assessment.fromJson(jsonDecode(res.body));
          });
    } catch (e) {
      print(e.toString());
    }
  }
}

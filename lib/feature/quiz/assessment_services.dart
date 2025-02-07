import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/quiz/model/Assessment.dart';

class AssessmentServices {
  static void getAssessment(BuildContext context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      print("Getting quiz");
      http.Response res = await http.get(
        Uri.parse('${Endpoints.baseURL}/assessment/static'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': user.token
        },
      );
      print("Gettin");

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("Got quiz");
            // print(res.body);
            Assessment questions = Assessment.fromJson(jsonDecode(res.body));
            print(questions.questions);
          });
    } catch (e) {
      print(e.toString());
    }
  }
}

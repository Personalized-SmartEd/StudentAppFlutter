import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/widgets/snackbar.dart';

class ClassroomServices {
  static Future<void> joinClassRoom(
      {required BuildContext context, required String id}) async {
    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print(userProvider.user.Token);
      print("getting quizs");
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/classroom/join'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
        body: jsonEncode(<String, dynamic>{
          "classroom_id": id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          print(res.body);
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context,
          " Check your Internet connection / Its probably your fault ");
    }
  }
}

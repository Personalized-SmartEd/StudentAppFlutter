import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/widgets/snackbar.dart';

class AuthServices {
  void getUserData(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = await prefs.getString("user");
    print("user ");
    print(user);
    if (user == null || user == "") {
      await prefs.setString('user', '');
      print("setting to null");
      User user = User(
        id: '',
        name: '',
        age: 0,
        password: '',
        email: '',
        studentID: '',
        image: '',
        schoolName: '',
        schoolCode: '',
        subjects: [],
        pace: '',
        className: '',
        performance: 0,
        performanceLvl: '',
        pastPerformance: [],
        learningStyle: [],
        token: '',
        refreshToken: '',
        createdAt: '',
        updatedAt: '',
      );
      userProvider.setUserFromModel(user);
    } else {
      userProvider.setUser(User.fromJson(jsonDecode(user)));
    }
  }

  void loginUser({
    required BuildContext context,
    required String password,
    required String email,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'All fields are required.');
      return;
    }
    print(password);

    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      print("logging in");
      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      print('Response status: ${res.statusCode}');
      print('Response status: ${res}');
      print('Response body: ${res.body}');
      print('Response real body: ${jsonDecode(res.body)}');
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userbody = jsonDecode(res.body);

          userProvider.setUser(User.fromJson(userbody));
          await prefs.setString(
            'token',
            jsonEncode(jsonDecode(res.body)['body']),
          );
          await prefs.setString(
            'refreshToken',
            jsonEncode(jsonDecode(res.body)['body']),
          );

          String userid = userbody['id'];

          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, " error ?? ${e.toString()}");
    }
  }
}

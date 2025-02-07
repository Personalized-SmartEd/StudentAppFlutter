import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/feature/splash/splash_screen.dart';
import 'package:smarted/widgets/snackbar.dart';

class AuthServices {
  static void getUserData(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = await prefs.getString("user");
    if (user == null || user == "") {
      print("user is null");
      await prefs.setString('user', '');
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

  static Future<void> loginUser({
    required BuildContext context,
    required String password,
    required String email,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'All fields are required.');
      return;
    }

    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
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

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userbody = jsonDecode(res.body);

          userProvider.setUser(User.fromJson(userbody));
          await prefs.setString(
            'user',
            jsonEncode(jsonDecode(res.body)),
          );

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

  static void logout(BuildContext context) async {
    final navigator = Navigator.of(context);

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    print(user);
    await prefs.setString('user', '');
    User usernew = User(
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

    userProvider.setUserFromModel(usernew);
    navigator.push(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  static Future<void> signupUser({
    required BuildContext context,
    required String password,
    required String email,
    required String Name,
    required int Age,
    required String SchoolName,
    required String SchoolCode,
    required File Image,
    required List<String> Subjects,
    required String Class,
  }) async {
    if (email.isEmpty ||
        password.isEmpty ||
        Name.isEmpty ||
        Age == 0 ||
        SchoolName.isEmpty ||
        SchoolCode.isEmpty ||
        Subjects.isEmpty ||
        Class.isEmpty) {
      showSnackBar(context, 'All fields are required.');
      return;
    }

    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Endpoints.baseURL}/signup'),
      );
      request.fields.addAll({
        'Name': Name,
        'Age': Age.toString(), // Convert int to String if required
        'Password': password,
        'Email': email,
        'SchoolName': SchoolName,
        'SchoolCode': SchoolCode,
        'Subjects': jsonEncode(Subjects),
        'Class': Class,
      });

      request.files
          .add(await http.MultipartFile.fromPath('Image', Image!.path));
      http.StreamedResponse response = await request.send();
      if (response.statusCode < 300) {
        print(await response.stream.bytesToString());

        showSnackBar(context, "User created successfully.");
      } else {
        print(response.reasonPhrase);
        showSnackBar(context, "Failed to create user.");
        // Handle error here
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, " error ?? ${e.toString()}");
    }
  }
}

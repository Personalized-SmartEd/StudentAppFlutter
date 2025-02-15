import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/core/network/http_handler.dart';
import 'package:smarted/feature/auth/login/login_page.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/feature/splash/splash_screen.dart';
import 'package:smarted/feature/studyplan/studyplanprovider.dart';
import 'package:smarted/widgets/snackbar.dart';

class AuthServices {
  static void getUserData(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = await prefs.getString("user");
    print(user);
    // await prefs.setString('user', '');
    if (user == null || user == "") {
      print("user is null");
      await prefs.setString('user', '');
      User user = User(
        id: '',
        Name: '',
        Age: 0,
        Password: '',
        Email: '',
        StudentID: '',
        Image: '',
        SchoolName: '',
        SchoolCode: '',
        Subjects: [],
        Pace: '',
        Performance: 0,
        PerformanceLvl: '',
        PastPerformance: [],
        LearningStyle: '',
        Token: '',
        RefreshToken: '',
        createdAt: '',
        updatedAt: '',
        ClassNumber: '',
        ClassCode: [],
      );
      userProvider.setUserFromModel(user);
    } else {
      var jsons = jsonDecode(user);
      if (jsons is String) {
        jsons = jsonDecode(jsons);
      }
      userProvider.setUser(User.fromMap(jsons));
    }
  }

  static Future<void> loginUser({
    required BuildContext context,
    required String Password,
    required String Email,
  }) async {
    if (Email.isEmpty || Password.isEmpty) {
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
          'Email': Email,
          'Password': Password,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userbody = jsonDecode(res.body);
          print(userbody);
          userProvider.setUser(User.fromMap(userbody));
          await prefs.setString(
            'user',
            jsonEncode(jsonDecode(res.body)),
          );

          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context,
          " Check your Internet connection / Its probably your fault ");
    }
  }

  static void logout(BuildContext context) async {
    final navigator = Navigator.of(context);

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var studyplanprovider =
        Provider.of<StudyPlanProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    print(user);
    await prefs.setString('user', '');
    await prefs.setString('studyplan', '');
    studyplanprovider.setStudyplan('');
    User usernew = User(
      id: '',
      Name: '',
      Age: 0,
      Password: '',
      Email: '',
      StudentID: '',
      Image: '',
      SchoolName: '',
      SchoolCode: '',
      Subjects: [],
      Pace: '',
      Performance: 0,
      PerformanceLvl: '',
      PastPerformance: [],
      LearningStyle: '',
      Token: '',
      RefreshToken: '',
      createdAt: '',
      updatedAt: '',
      ClassNumber: '',
      ClassCode: [],
    );

    userProvider.setUserFromModel(usernew);

    navigator.push(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  static Future<void> signupUser({
    required BuildContext context,
    required String Password,
    required String Email,
    required String Name,
    required String Age, // We will sanitize this
    required String SchoolName,
    required String SchoolCode,
    required File Image,
    required List<String> Subjects,
    required String Class,
  }) async {
    List<String> emptyFields = [];

    if (Email.trim().isEmpty) emptyFields.add("Email");
    if (Password.trim().isEmpty) emptyFields.add("Password");
    if (Name.trim().isEmpty) emptyFields.add("Name");
    if (Age.trim().isEmpty) emptyFields.add("Age");
    if (SchoolName.trim().isEmpty) emptyFields.add("School Name");
    if (SchoolCode.trim().isEmpty) emptyFields.add("School Code");
    if (Subjects.isEmpty) emptyFields.add("Subjects");
    if (Class.trim().isEmpty) emptyFields.add("Class");
    if (Image.path.isEmpty) emptyFields.add("Profile Image");

    if (emptyFields.isNotEmpty) {
      showSnackBar(context, "Please fill in: ${emptyFields.join(', ')}");
      return;
    }

    // 🔹 Trim and sanitize Age input
    String cleanedAge = Age.trim()
        .replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric chars

    // 🔹 Convert Age to int
    int? ageInt = int.tryParse(cleanedAge);
    if (ageInt == null || ageInt <= 0) {
      showSnackBar(context, "Invalid Age. Please enter a valid number.");
      return;
    }

    print("DEBUG: Sending Age as: $Class");

    try {
      final navigator = Navigator.of(context);
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('${Endpoints.baseURL}/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'Name': Name,
          'Age': 22,
          'Password': Password,
          'Email': Email,
          'SchoolName': SchoolName,
          'SchoolCode': SchoolCode,
          'Subjects': Subjects,
          'ClassNumber': 7,
          'Image': 'Image',
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          );
        },
      );
    } catch (e, stackTrace) {
      print("Signup Error: $e\nStack Trace: $stackTrace");
      showSnackBar(context, "An error occurred: ${e.toString()}");
    }
  }

  static Future<User> getUserById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('${Endpoints.baseURL}/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userProvider.user.Token,
        },
      );
      User user = User(
        id: '',
        Name: '',
        Age: 0,
        Password: '',
        Email: '',
        StudentID: '',
        Image: '',
        SchoolName: '',
        SchoolCode: '',
        Subjects: [],
        Pace: '',
        Performance: 0,
        PerformanceLvl: '',
        PastPerformance: [],
        LearningStyle: '',
        Token: '',
        RefreshToken: '',
        createdAt: '',
        updatedAt: '',
        ClassNumber: '',
        ClassCode: [],
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final userbody = jsonDecode(res.body);
          print(userbody);
          user = User.fromMap(userbody);
        },
      );
      return user;
    } catch (e) {
      print(e.toString());
      showSnackBar(context,
          " Check your Internet connection / Its probably your fault ");
      return User(
        id: '',
        Name: '',
        Age: 0,
        Password: '',
        Email: '',
        StudentID: '',
        Image: '',
        SchoolName: '',
        SchoolCode: '',
        Subjects: [],
        Pace: '',
        Performance: 0,
        PerformanceLvl: '',
        PastPerformance: [],
        LearningStyle: '',
        Token: '',
        RefreshToken: '',
        createdAt: '',
        updatedAt: '',
        ClassNumber: '',
        ClassCode: [],
      );
    }
  }
}

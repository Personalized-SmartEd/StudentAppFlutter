import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyPlanProvider extends ChangeNotifier {
  // Initializing the user with default values
  dynamic studyplan = "";

  // Getter to access the user object
  dynamic get getstudyplan => studyplan;

  // Load user data from SharedPreferences when the provider is initialized
  Future<void> loadStudyPlan() async {
    final prefs = await SharedPreferences.getInstance();
    String? studyplans = await prefs.getString('studyplan');
    print(studyplans);
    if (studyplans != null && studyplans.isNotEmpty) {
      try {
        final Map<String, dynamic> studyplanmap =
            jsonDecode(studyplans); // Ensure correct decoding
        studyplan = studyplanmap; // Convert to User object
        notifyListeners();
      } catch (e) {
        print("Error decoding user data: $e");
      }
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'studyplan',
      jsonEncode(studyplan),
    );
  }
  

  // Method to update user data from a User object
  void setStudyplan(dynamic studyplann) {
    studyplan = studyplann;
    // Save to SharedPreferences
    _saveUserToPrefs();
    notifyListeners();
  }

  // Method to update a specific field in the user object
}

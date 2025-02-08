import 'package:flutter/material.dart';
import 'package:smarted/feature/auth/model/user.dart';

class UserProvider extends ChangeNotifier {
  // Initializing the user with default values
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
    performance: 0,
    performanceLvl: '',
    pastPerformance: [],
    learningStyle: '',
    token: '',
    refreshToken: '',
    createdAt: '',
    updatedAt: '',
    classNumber: '',
    classCode: '',
  );

  // Getter to access the user object
  User get getUser => user;

  // Method to update user data from a User object
  void setUser(User newUser) {
    user = newUser;
    notifyListeners(); // Notify listeners to update the UI
  }

  void setUserFromModel(User newUser) {
    user = newUser;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to update a specific field in the user object
  void updateUser({
    String? id,
    String? name,
    int? age,
    String? password,
    String? email,
    String? studentID,
    String? image,
    String? schoolName,
    String? schoolCode,
    List<String>? subjects,
    String? pace,
    String? classCode,
    String? classNumber,
    int? performance,
    String? performanceLvl,
    List<int>? pastPerformance,
    String? learningStyle,
    String? token,
    String? refreshToken,
    String? createdAt,
    String? updatedAt,
  }) {
    if (id != null) user.id = id;
    if (name != null) user.name = name;
    if (age != null) user.age = age;
    if (password != null) user.password = password;
    if (email != null) user.email = email;
    if (studentID != null) user.studentID = studentID;
    if (image != null) user.image = image;
    if (schoolName != null) user.schoolName = schoolName;
    if (schoolCode != null) user.schoolCode = schoolCode;
    if (subjects != null) user.subjects = subjects;
    if (pace != null) user.pace = pace;
    if (classCode != null) user.classCode = classCode;
    if (classNumber != null) user.classNumber = classNumber;
    if (performance != null) user.performance = performance;
    if (performanceLvl != null) user.performanceLvl = performanceLvl;
    if (pastPerformance != null) user.pastPerformance = pastPerformance;
    if (learningStyle != null) user.learningStyle = learningStyle;
    if (token != null) user.token = token;
    if (refreshToken != null) user.refreshToken = refreshToken;
    if (createdAt != null) user.createdAt = createdAt;
    if (updatedAt != null) user.updatedAt = updatedAt;

    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to update the user's token and refresh token
  void updateTokens(String newToken, String newRefreshToken) {
    user.token = newToken;
    user.refreshToken = newRefreshToken;
    notifyListeners(); // Notify listeners to update the UI
  }
}

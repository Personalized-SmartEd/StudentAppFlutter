import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarted/feature/auth/model/user.dart';

class UserProvider extends ChangeNotifier {
  // Initializing the user with default values
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

  // Getter to access the user object
  User get getUser => user;

  // Load user data from SharedPreferences when the provider is initialized
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    if (userData != null && userData.isNotEmpty) {
      try {
        final Map<String, dynamic> userMap =
            jsonDecode(userData); // Ensure correct decoding
        user = User.fromMap(userMap); // Convert to User object
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
      'user',
      jsonEncode(user),
    );
  }

  // Method to update user data from a User object
  void setUser(User newUser) {
    user = newUser;
    // Save to SharedPreferences
    notifyListeners();
  }

  void setUserFromModel(User newUser) {
    user = newUser;
    _saveUserToPrefs();
    notifyListeners();
  }

  // Method to update a specific field in the user object
  Future<void> updateUser({
    String? id,
    String? Name,
    int? Age,
    String? Password,
    String? Email,
    String? StudentID,
    String? Image,
    String? SchoolName,
    String? SchoolCode,
    List<String>? Subjects,
    String? Pace,
    List<String>? ClassCode,
    String? ClassNumber,
    int? Performance,
    String? PerformanceLvl,
    List<int>? PastPerformance,
    String? LearningStyle,
    String? Token,
    String? RefreshToken,
    String? createdAt,
    String? updatedAt,
  }) async {
    if (id != null) user.id = id;
    if (Name != null) user.Name = Name;
    if (Age != null) user.Age = Age;
    if (Password != null) user.Password = Password;
    if (Email != null) user.Email = Email;
    if (StudentID != null) user.StudentID = StudentID;
    if (Image != null) user.Image = Image;
    if (SchoolName != null) user.SchoolName = SchoolName;
    if (SchoolCode != null) user.SchoolCode = SchoolCode;
    if (Subjects != null) user.Subjects = Subjects;
    if (Pace != null) user.Pace = Pace;
    if (ClassCode != null) user.ClassCode = ClassCode;
    if (ClassNumber != null) user.ClassNumber = ClassNumber;
    if (Performance != null) user.Performance = Performance;
    if (PerformanceLvl != null) user.PerformanceLvl = PerformanceLvl;
    if (PastPerformance != null) user.PastPerformance = PastPerformance;
    if (LearningStyle != null) user.LearningStyle = LearningStyle;
    if (Token != null) user.Token = Token;
    if (RefreshToken != null) user.RefreshToken = RefreshToken;
    if (createdAt != null) user.createdAt = createdAt;
    if (updatedAt != null) user.updatedAt = updatedAt;

    _saveUserToPrefs(); // Save changes to SharedPreferences
    notifyListeners();
  }

  // Method to update the user's Token and refresh Token
  void updateTokens(String newToken, String newRefreshToken) {
    user.Token = newToken;
    user.RefreshToken = newRefreshToken;
    _saveUserToPrefs(); // Save to SharedPreferences
    notifyListeners();
  }
}

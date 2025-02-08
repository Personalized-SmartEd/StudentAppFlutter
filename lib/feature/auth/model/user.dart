import 'dart:convert';

class User {
  String id;
  String name;
  int age;
  String password;
  String email;
  String studentID;
  String image;
  String schoolName;
  String schoolCode;
  List<String> subjects;
  String pace;
  String classNumber;
  String classCode;
  int performance;
  String performanceLvl;
  List<int> pastPerformance;
  String learningStyle;
  String token;
  String refreshToken;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.password,
    required this.email,
    required this.studentID,
    required this.image,
    required this.schoolName,
    required this.schoolCode,
    required this.subjects,
    required this.pace,
    required this.classNumber,
    required this.classCode,
    required this.performance,
    required this.performanceLvl,
    required this.pastPerformance,
    required this.learningStyle,
    required this.token,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert User object to a Map (useful for sending data)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'password': password,
      'email': email,
      'studentID': studentID,
      'image': image,
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'subjects': subjects,
      'pace': pace,
      'classNumber': classNumber,
      'classCode': classCode,
      'performance': performance,
      'performanceLvl': performanceLvl,
      'pastPerformance': pastPerformance,
      'learningStyle': learningStyle,
      'token': token,
      'refreshToken': refreshToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert a Map into a User object (Fixed)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['Name'] ?? '',
      age: (map['Age'] is int)
          ? map['Age']
          : int.tryParse(map['Age'].toString()) ?? 0,
      password: map['Password'] ?? '',
      email: map['Email'] ?? '',
      studentID: map['StudentID'] ?? '',
      image: map['Image'] ?? '',
      schoolName: map['SchoolName'] ?? '',
      schoolCode: map['SchoolCode'] ?? '',
      subjects: List<String>.from(map['Subjects'] ?? []),
      pace: map['Pace'] ?? '',
      classNumber: map['ClassNumber'].toString(), // Convert int to String
      classCode: map['ClassCode'] ?? '',
      performance: (map['Performance'] is int) ? map['Performance'] : 0,
      performanceLvl: map['PerformanceLvl'] ?? '',
      pastPerformance: List<int>.from(map['PastPerformance'] ?? [0]),
      learningStyle: map['LearningStyle'] ?? '',
      token: map['Token'] ?? '',
      refreshToken: map['RefreshToken'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  /// Convert User object to JSON
  String toJson() => json.encode(toMap());

  /// Convert JSON string to User object
  factory User.fromJson(String source) {
    final Map<String, dynamic> decodedMap = json.decode(source);
    return User.fromMap(decodedMap);
  }
}

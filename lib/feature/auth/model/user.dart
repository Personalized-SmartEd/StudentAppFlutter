import 'dart:convert';

class User {
  String id;
  String Name;
  int Age;
  String Password;
  String Email;
  String StudentID;
  String Image;
  String SchoolName;
  String SchoolCode;
  List<String> Subjects;
  String Pace;
  String ClassNumber;
  List<String> ClassCode;
  int Performance;
  String PerformanceLvl;
  List<int> PastPerformance;
  String LearningStyle;
  String Token;
  String RefreshToken;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.Name,
    required this.Age,
    required this.Password,
    required this.Email,
    required this.StudentID,
    required this.Image,
    required this.SchoolName,
    required this.SchoolCode,
    required this.Subjects,
    required this.Pace,
    required this.ClassNumber,
    required this.ClassCode,
    required this.Performance,
    required this.PerformanceLvl,
    required this.PastPerformance,
    required this.LearningStyle,
    required this.Token,
    required this.RefreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert object to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': Name,
      'Age': Age,
      'Password': Password,
      'Email': Email,
      'StudentID': StudentID,
      'Image': Image,
      'SchoolName': SchoolName,
      'SchoolCode': SchoolCode,
      'Subjects': Subjects,
      'Pace': Pace,
      'ClassNumber': ClassNumber,
      'ClassCode': ClassCode,
      'Performance': Performance,
      'PerformanceLvl': PerformanceLvl,
      'PastPerformance': PastPerformance,
      'LearningStyle': LearningStyle,
      'Token': Token,
      'RefreshToken': RefreshToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Factory constructor to create a User object from JSON
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      Name: map['Name']?.toString() ?? '', // Ensure lowercase key
      Age: (map['Age'] is int)
          ? map['Age']
          : int.tryParse(map['Age']?.toString() ?? '0') ?? 0,
      Password: map['Password']?.toString() ?? '',
      Email: map['Email']?.toString() ?? '',
      StudentID: map['StudentID']?.toString() ?? '',
      Image: map['Image']?.toString() ?? '',
      SchoolName: map['SchoolName']?.toString() ?? '',
      SchoolCode: map['SchoolCode']?.toString() ?? '',
      Subjects: (map['Subjects'] is List)
          ? List<String>.from(map['Subjects'])
          : [], // Handle type casting safely
      Pace: map['Pace']?.toString() ?? '',
      ClassNumber: map['ClassNumber']?.toString() ?? '',
      ClassCode:
          (map['ClassCode'] is List) ? List<String>.from(map['ClassCode']) : [],
      Performance: (map['Performance'] is int)
          ? map['Performance']
          : int.tryParse(map['Performance']?.toString() ?? '0') ?? 0,
      PerformanceLvl: map['PerformanceLvl']?.toString() ?? '',
      PastPerformance: (map['PastPerformance'] is List)
          ? List<int>.from(map['PastPerformance'])
          : [],
      LearningStyle: map['LearningStyle']?.toString() ?? '',
      Token: map['Token']?.toString() ?? '',
      RefreshToken: map['RefreshToken']?.toString() ?? '',
      createdAt: map['created_at']?.toString() ?? '',
      updatedAt: map['updated_at']?.toString() ?? '',
    );
  }

  /// Convert object to JSON string
  String toJson() => json.encode(toMap());

  /// Create a User object from a JSON string
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

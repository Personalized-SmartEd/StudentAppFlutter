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
  String className;
  int performance;
  String performanceLvl;
  List<int> pastPerformance;
  List<String> learningStyle;
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
    required this.className,
    required this.performance,
    required this.performanceLvl,
    required this.pastPerformance,
    required this.learningStyle,
    required this.token,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['Name'],
        age = json['Age'],
        password = json['Password'],
        email = json['Email'],
        studentID = json['StudentID'],
        image = json['Image'],
        schoolName = json['SchoolName'],
        schoolCode = json['SchoolCode'],
        subjects = List<String>.from(json['Subjects']),
        pace = json['Pace'],
        className = json['Class'],
        performance = json['Performance'],
        performanceLvl = json['PerformanceLvl'],
        pastPerformance = List<int>.from(json['PastPerformance']),
        learningStyle = List<String>.from(json['LearningStyle']),
        token = json['Token'],
        refreshToken = json['RefreshToken'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Age': age,
      'Password': password,
      'Email': email,
      'StudentID': studentID,
      'Image': image,
      'SchoolName': schoolName,
      'SchoolCode': schoolCode,
      'Subjects': subjects,
      'Pace': pace,
      'Class': className,
      'Performance': performance,
      'PerformanceLvl': performanceLvl,
      'PastPerformance': pastPerformance,
      'LearningStyle': learningStyle,
      'Token': token,
      'RefreshToken': refreshToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

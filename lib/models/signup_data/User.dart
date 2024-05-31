class User {
  String userId;
  String email;
  String password;
  String name;
  String gender;
  String birthDate;
  String birthTime;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.birthTime,
  });

  // JSON 데이터를 User 객체로 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      birthTime: json['birth_time'],
    );
  }

  // User 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'password': password,
      'name': name,
      'gender': gender,
      'birth_date': birthDate,
      'birth_time': birthTime,
    };
  }
}

class UserModel {
  String? firebaseId;
  final String id;
  final String email;
  final String pwd;

  UserModel(
      {required this.id,
      required this.email,
      required this.pwd,
      this.firebaseId});

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'pwd': pwd,
    };
  }

  // Factory method to create a User instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firebaseId: json['firebaseId'],
      id: json['id'],
      email: json['email'],
      pwd: json['pwd'],
    );
  }
}

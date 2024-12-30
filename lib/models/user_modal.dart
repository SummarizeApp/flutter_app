class UserModel {
  final String id;
  final String username;
  final String password;
  final String email;
  final String connactNumber;

  UserModel({required this.id, required this.username, required this.password, required this.email, required this.connactNumber});

factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password:  json['password'], 
      connactNumber: json ['connactNumber']
    );
  }

}
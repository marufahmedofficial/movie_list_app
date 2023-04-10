const String tableUser = 'tbl_user';
const String tblUserColId = 'user_id';
const String tblUserColEmail = 'email';
const String tblUserColPassword = 'password';

class UserModel {
  int? userId;
  String email;
  String password;

  UserModel({
    this.userId,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    final map = <String,dynamic>{
      tblUserColEmail : email,
      tblUserColPassword : password,
    };
    if(userId != null) {
      map[tblUserColId] = userId;
    }
    return map;
  }

  factory UserModel.fromMap
      (Map<String,dynamic> map) =>
      UserModel(
    userId: map[tblUserColId],
    email: map[tblUserColEmail],
    password: map[tblUserColPassword],
  );
}
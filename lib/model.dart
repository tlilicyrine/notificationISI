class UserModel {
  String? email;
  String? role;
  String? uid;

  UserModel({this.uid, this.email, this.role});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
    );
  }

  get subscribedCategory => null;
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
    };
  }
}
class StudentModel extends UserModel {
  String? subscribedCategory;

  StudentModel({super.uid, super.email, super.role, this.subscribedCategory});

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      subscribedCategory: map['subscribedCategory'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap(); 
    map['subscribedCategory'] = subscribedCategory;
    return map;
  }
}
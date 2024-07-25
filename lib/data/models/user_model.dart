class UserModel {
  String? userId;
  String? name;
  String? email;
  String? mobNo;
  String? gender;
  String? createdAt;
  bool isOnline = false;
  int? status = 1; //1-> Active, 2-> InActive, 3-> Suspended
  String? profilePic = '';
  int? profileStatus = 1; //1-> Public, 2-> Friends, 3-> Private

  UserModel(
      {this.userId,
       this.name,
       this.email,
       this.mobNo,
       this.gender,
       this.createdAt,
       this.isOnline = true,
       this.status,
       this.profilePic,
       this.profileStatus});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
        name: json['name'],
        email: json['email'],
        mobNo: json['mobNo'],
        gender: json['gender'],
        createdAt: json['createdAt'],
        isOnline: json['isOnline'],
        status: json['status'],
        profilePic: json['profilePic'],
        profileStatus: json['profileStatus']);
  }

  Map<String,  dynamic> toMap(){
    return {
      'userId' : userId,
      'name' : name,
      'email' : email,
      'mobNo' : mobNo,
      'gender' : gender,
      'createdAt' : createdAt,
      'isOnline' : isOnline,
      'status' : status,
      'profilePic' : profilePic,
      'profileStatus' : profileStatus,
    };
  }

}

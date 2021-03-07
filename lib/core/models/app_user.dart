class AppUser {
  String id;
  String email;
//  String fcmToken;
  String fullName;
//  String phoneNumber;
  String imgUrl;

  AppUser({
    this.email,
//    this.fatherName,
//    this.fcmToken,
    this.fullName,
//    this.password,
//    this.phoneNumber,
    this.id,
    this.imgUrl,
  });

  AppUser.fromJson(Map<String, dynamic> json, id) {
    print('@student.fromJson : ${json.toString()}');
    email = json['email'];
//    fatherName = json['fatherName'];
//    fcmToken = json['fcmToken'];
    fullName = json['fullName'];
//    password = json['password'];
//    phoneNumber = json['phoneNumber'];
    this.imgUrl = json['imgUrl'];
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
//    data['fatherName'] = this.fatherName;
//    data['fcmToken'] = this.fcmToken;
    data['fullName'] = this.fullName;
//    data['password'] = this.password;
//    data['phoneNumber'] = this.phoneNumber;
    data['imgUrl'] = this.imgUrl;
    data['id'] = this.id;
    return data;
  }
}

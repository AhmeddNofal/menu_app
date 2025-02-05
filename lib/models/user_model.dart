class User {
  int? id;
  bool? admin;
  String? email;
  String? password;


  User({this.admin, this.email, this.password});

  User.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    admin = map["admin"] == 1;
    email = map["email"];
    password = map["password"];
  }

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      "admin": admin == true ? 1 : 0,
      "email": email,
      "password": password
    };
    if (id != null) {
      map["_id"] = id;
    }

    return map;
  }
}

import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

class User {
  int? id;
  late bool admin;
  late String email;
  late String password;

  User(this.admin, this.email, this.password);

  User.fromMap(Map<String, dynamic> map) {
    id = map["id"];
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
      map["id"] = id;
    }

    return map;
  }
}

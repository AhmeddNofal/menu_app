class Meal {
  int? id;
  String? title;
  String? description;
  String? image;
  List<bool> days = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Meal({this.title, this.description, this.image});

  Meal.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    title = map["title"];
    description = map["description"];
    image = map["image"];
    days = map["days"];
  }

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "description": description,
      "image": image,
      "days": days
    };
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
